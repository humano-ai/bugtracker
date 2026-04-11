Title: Wrong Max-Age parsing using local timezone
Author: Rodrigo Arias Mallo
Created: Sat, 11 Apr 2026 10:57:28 +0200
State: open

With this cookie configuration:

    % cat ~/.dillo/cookiesrc
    DEFAULT DENY

    smolfedi.pollux.casa ACCEPT_SESSION
    projects.polymaths.social ACCEPT_SESSION

It seems the cookie being set is not retrieved correctly:

    Nav_open_url: new url='https://projects.polymaths.social/auth/sign_in'
    Connecting to 217.182.138.233:443
    >>> sending HTTP:
    POST /auth/sign_in HTTP/1.1\x0D
    ...

    <<< receiving HTTP:
    HTTP/1.1 302 Found
    Location: /oauth/authorize
    Set-Cookie: gotosocial-projects.polymaths.social=...; Path=/; Domain=projects.polymaths.social; Expires=Sat, 11 Apr 2026 08:44:23 GMT; Max-Age=120; HttpOnly; Secure; SameSite=Lax
    ...

    [cookies dpi]: projects.polymaths.social SETTING: gotosocial-projects.polymaths.social=...; Path=/; Domain=projects.polymaths.social; Expires=Sat, 11 Apr 2026 08:44:23 GMT; Max-Age=120; HttpOnly; Secure; SameSite=Lax
    [cookies dpi]: Cookie contains unknown attribute: 'SameSite'

    Redirect to: https://projects.polymaths.social/oauth/authorize
    Nav_open_url: new url='https://projects.polymaths.social/oauth/authorize'
    Connecting to 217.182.138.233:443

    [ missing cookie get! ]

    >>> sending HTTP:
    GET /oauth/authorize HTTP/1.1\x0D
    Host: projects.polymaths.social\x0D
    User-Agent: Dillo/3.2.0\x0D
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\x0D
    Accept-Language: en-US\x0D
    Accept-Encoding: gzip, deflate, br\x0D
    DNT: 1\x0D
    Connection: keep-alive\x0D
    Pragma: no-cache\x0D
    Cache-Control: no-cache\x0D <--- missing Cookie header!
    \x0D

Can this be a problem with `Cookies_control_check`?

    /**
     * Return a string containing cookie data for an HTTP query.
     */
    char *a_Cookies_get_query(const DilloUrl *query_url, const DilloUrl *requester,
                              int is_root_url)
    {
       char *cmd, *dpip_tag, *query;
       const char *path;
       CookieControlAction action;
    
       if (disabled)
          return dStrdup("");
    
       action = Cookies_control_check(query_url);
       if (action == COOKIE_DENY) {
          _MSG("Cookies: denied GET for %s\n", URL_HOST_(query_url));
          return dStrdup("");
       }
    ...

It doesn't seem to be the problem. It seems that we are getting an empty cookie:

    [cookies dpi]: projects.polymaths.social SETTING: gotosocial-projects.polymaths.social=...; Path=/; Domain=projects.polymaths.social; Expires=Sat, 11 Apr 2026 09:11:47 GMT; Max-Age=120; HttpOnly; Secure; SameSite=Lax
    [cookies dpi]: Cookie contains unknown attribute: 'SameSite'
    Redirect to: https://projects.polymaths.social/oauth/authorize
    Nav_open_url: new url='https://projects.polymaths.social/oauth/authorize'
    Connecting to 217.182.138.233:443
    cookies.c: a_Dpi_send_blocking_cmd cmd = {<cmd='get_cookie' scheme='https' host='projects.polymaths.social' path='/oauth/authorize' '>}
    cookies.c: after a_Dpi_send_blocking_cmd resp={<cmd='get_cookie_answer' cookie='' '>} <---- HERE
    >>> sending HTTP:
    GET /oauth/authorize HTTP/1.1\x0D
    ...

Printing the expired cookie message shows what is going on:

    [cookies dpi]: projects.polymaths.social SETTING: gotosocial-projects.polymaths.social=...; Path=/; Domain=projects.polymaths.social; Expires=Sat, 11 Apr 2026 09:20:00 GMT; Max-Age=120; HttpOnly; Secure; SameSite=Lax
    [cookies dpi]: Cookie contains unknown attribute: 'SameSite'
    [cookies dpi]: Ignoring expired cookie gotosocial-projects.polymaths.social=... d:projects.polymaths.social p:/

    % date -u
    Sat Apr 11 09:18:30 AM UTC 2026

The cookie comes with a short max-age of 120 seconds (2 minutes) but Dillo is
considering that it has already expired. This seems to be caused because we are
not properly parsing the timezone of the cookie.
