Title: Mastodon OAuth fails with referer=host
Author: Rodrigo Arias Mallo
Created: Fri, 10 Apr 2026 21:58:13 +0200
State: open

The Mastodon OAuth login seems to be failing to redirect back to Smolfedi when
the user needs to login first and Dillo has `http_referer=host`. If the user is
already logged into Mastodon, the login works fine (probably because we don't
pass through the problematic endpoint).

Here are the trace logs with the credentials removed of a failed attempt.

[Full trace log](log.txt)

Here is a short view:

    % cat .dillo/cookiesrc
    DEFAULT DENY

    fosstodon.org ACCEPT_SESSION
    smolfedi.pollux.casa ACCEPT_SESSION


    % dillo https://smolfedi.pollux.casa/login.php
    ...
    Nav_open_url: new url='https://smolfedi.pollux.casa/login.php'
    ...
    >>> sending HTTP:
    GET /login.php HTTP/1.1\x0D
    ...
    Referer: https://smolfedi.pollux.casa/\x0D

    <<< receiving HTTP:
    HTTP/1.1 200 OK
    ...

    >>> sending HTTP:
    POST /login.php HTTP/1.1\x0D
    ...
    Referer: https://smolfedi.pollux.casa/\x0D
    \x0D
    instance=fosstodon.org

    <<< receiving HTTP:
    HTTP/1.1 302 Found
    ...
    Location: https://fosstodon.org/oauth/authorize?client_id=xxxxxxxx&redirect_uri=https%3A%2F%2Fsmolfedi.pollux.casa%2Fcallback.php&response_type=code&scope=read+write+follow&state=xxxxxx

    >>> sending HTTP:
    GET /oauth/authorize?client_id=xxxxxxxx&redirect_uri=https%3A%2F%2Fsmolfedi.pollux.casa%2Fcallback.php&response_type=code&scope=read+write+follow&state=xxxxxx HTTP/1.1\x0D
    ...
    Referer: https://fosstodon.org/\x0D

    <<< receiving HTTP:
    HTTP/1.1 302 Found
    ...
    location: https://fosstodon.org/auth/sign_in

    >>> sending HTTP:
    GET /auth/sign_in HTTP/1.1\x0D
    ...
    Referer: https://fosstodon.org/\x0D

    <<< receiving HTTP:
    HTTP/1.1 200 OK
    ...

    >>> sending HTTP:
    POST /auth/sign_in HTTP/1.1\x0D
    ...
    Referer: https://fosstodon.org/\x0D
    \x0D
    authenticity_token=xxx&user%5Bemail%5D=xxx&user%5Bpassword%5D=xxx&button=

    <<< receiving HTTP:
    HTTP/1.1 302 Found
    ...
    location: https://fosstodon.org/ <--- wrong redirect!


This problem may be occurring because the "Referer" that Dillo uses by default
removes the path (only uses the host).

If this were the case, then Mastodon could be refusing the OAuth by checking
the "Referer" header.

When Dillo is configured with `http_referer=path`, then it works:

    >>> sending HTTP:
    GET /oauth/authorize?client_id=xxxxxx&redirect_uri=https%3A%2F%2Fsmolfedi.pollux.casa%2Fcallback.php&response_type=code&scope=read+write+follow&state=xxxxx HTTP/1.1\x0D
    Host: fosstodon.org\x0D
    User-Agent: Dillo/3.2.0\x0D
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\x0D
    Accept-Language: en-US\x0D
    Accept-Encoding: gzip, deflate, br\x0D
    DNT: 1\x0D
    Referer: https://fosstodon.org/oauth/authorize\x0D <--- see it has the path
    Connection: keep-alive\x0D
    Pragma: no-cache\x0D
    Cache-Control: no-cache\x0D
    \x0D

    <<< receiving HTTP:
    HTTP/1.1 302 Found
    ...
    location: https://fosstodon.org/auth/sign_in

    >>> sending HTTP:
    GET /auth/sign_in HTTP/1.1\x0D
    ...
    Referer: https://fosstodon.org/auth/sign_in\x0D <-- same

    <<< receiving HTTP:
    HTTP/1.1 200 OK
    ...

    >>> sending HTTP:
    POST /auth/sign_in HTTP/1.1\x0D
    ...
    Referer: https://fosstodon.org/auth/sign_in\x0D

    <<< receiving HTTP:
    HTTP/1.1 302 Found
    ...
    location: https://fosstodon.org/oauth/authorize?client_id=xxxx&redirect_uri=https%3A%2F%2Fsmolfedi.pollux.casa%2Fcallback.php&response_type=code&scope=read+write+follow&state=xxxx

    >>> sending HTTP:
    GET /oauth/authorize?client_id=xxxx&redirect_uri=https%3A%2F%2Fsmolfedi.pollux.casa%2Fcallback.php&response_type=code&scope=read+write+follow&state=xxxx HTTP/1.1\x0D
    ...
    Referer: https://fosstodon.org/oauth/authorize\x0D

    <<< receiving HTTP:
    HTTP/1.1 302 Found
    ...
    location: https://smolfedi.pollux.casa/callback.php?code=xxx&state=xxx

Now we get the proper redirect.

The same seems to be happening with `http_referer=none`.

Okay, so I have already debugged this in 2024:

<https://github.com/mastodon/mastodon/issues/31466#issuecomment-2297532161>

> The `/auth/sign_in` endpoint will only redirect back to `/oauth/authorize` if
> the Referer header is "properly" set. In Dillo is set by default to the host of
> the current URL, not the previous URL. This is controlled by the http_referer
> option. Changing it to none (not seding it) causes a failure in brutaldon.org.
> Changing it to "path" causes it to hold the value of the current URL, which
> works fine.

So, is this our fault or is Mastodon trying to follow the Referer? I'll need to
double check the OAuth spec to see if it requires Referer to be set.

It would be nice not to depend on Referer because is a header that any attacker
can control, so it doesn't provide any protection. We only set it to the host
value to prevent tracking and keep sites happy.

It looks like Mastodon doesn't use the Referer as redirect if:

- Is blank
- The path starts with `/auth`.

<https://raw.githubusercontent.com/mastodon/mastodon/8124d44ee1d800790a3a3cc5674091b2d7579fc7/app/controllers/application_controller.rb#L46>

    def store_referrer
      return if request.referer.blank?
    
      redirect_uri = URI(request.referer)
      return if redirect_uri.path.start_with?('/auth', '/settings/two_factor_authentication', '/settings/otp_authentication')
    
      stored_url = redirect_uri.to_s if redirect_uri.host == request.host && redirect_uri.port == request.port
    
      store_location_for(:user, stored_url)
    end

I would imagine that the best option it to *always* ignore the Referer header
and all CSRF mitigations are handled via forms.
