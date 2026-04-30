Title: Get rid of HSTS
Author: Rodrigo Arias Mallo
Created: Thu, 30 Apr 2026 20:44:34 +0200
State: open

HTTP Strict Transport Security (HSTS) is just a badly designed idea. See:

<https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security#Limitations>

So far we carried an (outdated) list of sites that are known to support HTTPS
and we forced the HTTPS protocol for those sites. Other sites advertise that
they support HTTPS from a HTTP(!!!) connection, so we should add them to the
list.

This poses two big problems. The first is that we have to keep a never ending
list which grows above the floppy disk limit, and we would need to permanently
keep it updated. The second problem is that a malicious site can store enough
domains in the HSTS list to create a super-cookie. This can be used to track
the user by performing multiple requests that will be controllably promoted to
HTTPS depending on the HSTS state, even if the cookies are disabled.

Given that the majority of the Web sites support HTTPS, we can instead just
have a list of exceptions of sites that don't support it, so we allow the HTTP
connection.

We can add a default entry which is to permit connections to the localhost
(127.0.0.1) with HTTP, so we can use local HTTP servers.

See also [412](/412) and [524](/524).
