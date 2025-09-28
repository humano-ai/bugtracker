Title: Handle errors in SSL_read() and SSL_write()
Author: rodarima
Created: Sat, 17 Feb 2024 12:04:39 +0000
State: closed

We cannot rely on the return value and the errno, the function SSL_get_error() must be used to determine what happen and if we need to retry again. A wrapper function translates the SSL error into a proper errno value.

In the case a premature EOF is sent by the server, the error queue is emptied before the error is returned.

Fixes: https://github.com/dillo-browser/dillo/issues/79