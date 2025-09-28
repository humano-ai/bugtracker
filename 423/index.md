Title: Add NetBSD default path for CA certificate bundle
Author: rodarima
Created: Sun, 27 Jul 2025 18:36:27 +0000
State: closed

In NetBSD the default CA certificate bundle for OpenSSL is located at `/etc/openssl/certs/ca-certificates.crt`, so we include it in the default search list so it works out of the box.

See: https://man.netbsd.org/certctl.8#FILES
See: https://wiki.netbsd.org/certctl-transition/