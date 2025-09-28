Title: Wiby.me search broken
Author: rodarima
Created: Sun, 17 Nov 2024 22:00:19 +0000
State: closed

We are missing the / in the GET query:

```
    GET ?q=dillo HTTP/1.1\r\n
    Host: wiby.me\r\n
    User-Agent: Dillo/3.1.1\r\n
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n
    Accept-Encoding: gzip, deflate\r\n
    DNT: 1\r\n
    Referer: http://wiby.me/\r\n
    Connection: keep-alive\r\n
    \r\n
```



--%--
From: rodarima
Date: Sun, 17 Nov 2024 22:34:49 +0000

This was fixed on dilloNG https://github.com/w00fpack/dilloNG/commit/bd50718a507872038ac8b4c40bf93e4f8c0a2a75

They set the url->path component to `/` when empty, but this is not a URI requirement, see https://datatracker.ietf.org/doc/html/rfc3986#section-3.3:

> If a URI contains an authority component, then the path component must either be empty or begin with a slash ("/") character. [...] A path is always defined for a URI, though the defined path may be empty (zero length).


This is only required for HTTP, see https://datatracker.ietf.org/doc/html/rfc7230#section-5.3.1:

> If the target URI's path component is empty, the client MUST send "/" as the path within the origin-form of request-target.

So I prefer to fix it on the http side.