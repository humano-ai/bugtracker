Title: Fix mbed TLS 3.6.0
Author: rodarima
Created: Mon, 06 May 2024 09:32:58 +0000
State: closed

Dillo is not working well with Mbed TLS 3.6.0:
```
% src/dillo https://dillo-browser.github.io/
dillo_dns_init: Here we go! (threaded)
TLS library: Mbed TLS 3.6.0
Trusting 147 TLS certificates.
Enabling cookies as from cookiesrc...
Nav_open_url: new url='https://dillo-browser.github.io/'
Dns_server [0]: dillo-browser.github.io is 185.199.110.153 185.199.109.153 185.199.111.153 185.199.108.153
Connecting to 185.199.110.153:443
mbedtls_ssl_handshake() failed with error -0x6c00
fd 6 is done and failed
```

See https://gitlab.alpinelinux.org/alpine/aports/-/issues/16088