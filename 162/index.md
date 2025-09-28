Title: Disable TLSv1.3 in MbedTLS 3.6.0 for now
Author: rodarima
Created: Mon, 06 May 2024 19:57:46 +0000
State: closed

In Mbed TLS 3.6.0 there is now support for TLSv1.3, but it requires special handling so for now we disable it.

See: https://gitlab.alpinelinux.org/alpine/aports/-/commit/4dc36afaa81a4d73758b29fa77981d07dbae0080.patch
Fixes: https://github.com/dillo-browser/dillo/issues/158