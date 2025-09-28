Title: EVP_PKEY_get_id deprecated since openssl 3.0
Author: th-otto
Created: Sat, 23 Dec 2023 13:19:26 +0000
State: closed

That function was deprecated since openssl 3.0.0, and no longer exists in newer versions. Consequently i get a warning during compile, and a link error at runtime.

(sorry but i have no idea how to properly replace it)

System: openSUSE; with openssl 3.1.4 installed

--%--
From: rodarima
Date: Sat, 23 Dec 2023 13:26:49 +0000

Can you paste the full error that you are getting? Following the documentation for OpenSSL 3.1, it seems to be supported:

https://www.openssl.org/docs/man3.1/man3/EVP_PKEY_get_id.html

Also, which commit are you using? I changed the OpenSSL implementation recently.

**Edit:** Based on:

> The EVP_PKEY_id() and EVP_PKEY_base_id() functions were renamed to include get in their names in OpenSSL 3.0, respectively. The old names are kept as non-deprecated alias macros. 

I suspect that you may be linking with an older OpenSSL, instead of 3.1.

--%--
From: th-otto
Date: Sat, 23 Dec 2023 13:42:28 +0000

Oops sorry, you are right. I had both an older version installed (openssl 1.1.0) as well as openssl-3, but only development files for the older version, so that was used instead.


--%--
From: rodarima
Date: Sat, 23 Dec 2023 13:45:34 +0000

I was planning to add support for OpenSSL 1.1 too, but for now only 3.x is supported. Anyway, this should be detected at configure time in any case. Thanks for the report :-)

--%--
From: th-otto
Date: Sat, 23 Dec 2023 13:56:42 +0000

Yes, support for openssl 1.1 would be  nice, since i have no port of openssl3 for atari (yet) ;)

BTW, in your readme you mention that you have no control of dillo.org anymore, but the about:splash page still has links to it (and is rendered quite strangely)


--%--
From: rodarima
Date: Sat, 23 Dec 2023 14:10:13 +0000

> Yes, support for openssl 1.1 would be nice, since i have no port of openssl3 for atari (yet) ;)

In the meanwhile, you can try with [mbedTLS](https://en.wikipedia.org/wiki/Mbed_TLS) in case it is already ported (use `--disable-openssl` to search only for mbedTLS).

> BTW, in your readme you mention that you have no control of dillo.org anymore, but the about:splash page still has links to it (and is rendered quite strangely)

Thanks, I opened #32 to address it.