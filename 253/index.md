Title: Allow cookies in a 302 redirection
Author: rodarima
Created: Tue, 20 Aug 2024 13:08:11 +0000
State: closed

Currently Dillo only accepts cookies for the same organization that caused the
initial request.

For example, if loading a page from server foo.org causes loading another
resource from bar.org, bar.org is not allowed to set any cookie.

This is a good protection against tracking [using third party
cookies](https://en.wikipedia.org/wiki/Third-party_cookies).

The problem with this approach is that the OAuth mechanism used by Mastodon, and
in particular used by Brutaldon causes a single request that begins from a POST
to the brutaldon.org server to continue in a fosstodon.org server.

Therefore, the fosstodon.org server cannot store cookies and the OAuth login
doesn't work.

We could allow cookies when the whole page location is changed to another page,
not a resource. This would continue to block third party resources while
allowing OAuth to work.

It would of course only work if the fosstodon.org domain is allowed to set
cookies in cookiesrc.

The side effect of not being able to use OAuth is that users may attempt to use
other methods, like logging in directly into Brutaldon by sending the user and
pass to the brutaldon.org server. This requires trusting the Brutaldon instance,
as the OAuth mechanism never discloses the credentials with it, and has a finer
grained access control to the protected resource.

The OAuth 2.0 mechanism is described in
[RFC-6749](https://datatracker.ietf.org/doc/html/rfc6749), but the specification
leaves out the usage of cookies to the implementation:

> 3.1.  Authorization Endpoint
> 
>    The authorization endpoint is used to interact with the resource
>    owner and obtain an authorization grant.  The authorization server
>    MUST first verify the identity of the resource owner.  The way in
>    which the authorization server authenticates the resource owner
>    (e.g., username and password login, session cookies) is beyond the
>    scope of this specification.

Similarly for CSRF protection:

> 10.12.  Cross-Site Request Forgery
> 
>    Cross-site request forgery (CSRF) is an exploit in which an attacker
>    causes the user-agent of a victim end-user to follow a malicious URI
>    (e.g., provided to the user-agent as a misleading link, image, or
>    redirection) to a trusting server (usually established via the
>    presence of a valid session cookie).
> 
>    A CSRF attack against the client's redirection URI allows an attacker
>    to inject its own authorization code or access token, which can
>    result in the client using an access token associated with the
>    attacker's protected resources rather than the victim's (e.g., save
>    the victim's bank account information to a protected resource
>    controlled by the attacker).
> 
>    The client MUST implement CSRF protection for its redirection URI.
>    This is typically accomplished by requiring any request sent to the
>    redirection URI endpoint to include a value that binds the request to
>    the user-agent's authenticated state (e.g., a hash of the session
>    cookie used to authenticate the user-agent).  The client SHOULD
>    utilize the "state" request parameter to deliver this value to the
>    authorization server when making an authorization request.

See: https://github.com/mastodon/mastodon/issues/31466

--%--
From: Rodrigo Arias Mallo
Date: Sun, 19 Oct 2025 19:37:44 +0200

Experimented with a new feature that allows sites to set third party cookies if
they are explicitly enabled in `cookiesrc`. This seems to work, but it is less
secure than the above suggestion in which we allow cookies if the root page is
causing the redirection, not on resources.

See: https://bugzilla.mozilla.org/show_bug.cgi?id=1465402 \
See: https://issues.chromium.org/issues/40508226

I'll need to think a bit more in how this could be potentially exploited by
advertising companies to track users. Given that the user will ultimately need
to enable any site from storing cookies, we at least already have a pretty good
standard by default.

The [RFC 6265](https://datatracker.ietf.org/doc/html/rfc6265) doesn't seem to
explicitly document what should happen with cookies are set in a redirection.

There are (at least) two cases that can cause the `requester` and `url`
arguments of `Nav_open_url()` to have a different organization:

1. The request is made by loading a resource from another server (image
   or stylesheet).
2. The request is made after a redirection of the root page to another server.

There is also the potential case in which a request of a resource returns a
redirect to another server, but we don't support redirections for resources, so
we can ignore this case for now.

--%--
From: Rodrigo Arias Mallo
Date: Sat, 25 Oct 2025 19:01:48 +0200

Fixed in https://git.dillo-browser.org/dillo/commit/?id=6a58684566f4d61bae7e3974023bc0989c3f2eb2
