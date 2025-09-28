Title: Use SSL_get1_peer_certificate() in OpenSSL 3
Author: rodarima
Created: Thu, 04 Apr 2024 22:00:33 +0000
State: closed

The function SSL_get_peer_certificate() is deprecated in 3.0.0, but still defined as a compatibility macro.

Fixes: https://github.com/dillo-browser/dillo/issues/118