Title: Add support for OpenSSL, mbedTLS 2 and mbedTLS 3
Author: rodarima
Created: Fri, 22 Dec 2023 19:57:16 +0000
State: closed

Fixes #20 

The `--enable-ssl` flag is renamed to `--enable-tls`.

Support for TLS (https) is now enabled by default unless explicitly disabled with `--disable-tls`.