Title: Always include the path "/" in HTTP requests
Author: rodarima
Created: Mon, 18 Nov 2024 18:19:19 +0000
State: closed

Following https://datatracker.ietf.org/doc/html/rfc7230#section-5.3.1, the path must not be empty, even if we have a query:

> If the target URI's path component is empty, the client MUST send "/"
> as the path within the origin-form of request-target.

Notice URIs can have empty paths, this is a restriction of HTTP only.

Fixes: https://github.com/dillo-browser/dillo/issues/302