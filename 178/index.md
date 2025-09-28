Title: Handle SSL_ERROR_ZERO_RETURN in OpenSSL
Author: rodarima
Created: Sat, 01 Jun 2024 18:39:15 +0000
State: closed

It may be returned when the server closes the connection, see:
https://www.openssl.org/docs/manmaster/man3/SSL_get_error.html

We simply handle it as if there was no error and return zero bytes read.

Fixes: https://github.com/dillo-browser/dillo/issues/175