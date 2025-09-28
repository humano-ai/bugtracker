Title: tls_openssl.c:(.text+0xc70): undefined reference to `SSL_get_peer_certificate' on NetBSD
Author: rodarima
Created: Tue, 02 Apr 2024 22:38:17 +0000
State: closed

We shouldn't be using SSL_get_peer_certificate():

https://www.openssl.org/docs/manmaster/man3/SSL_get_peer_certificate.html