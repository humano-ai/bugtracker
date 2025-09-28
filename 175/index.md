Title: SSL_read() failed: SSL_get_error() returned 6 while loading reddit.com
Author: rodarima
Created: Fri, 31 May 2024 19:57:04 +0000
State: closed

```
% dillo reddit.com
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.3.0 9 Apr 2024
Enabling cookies as from cookiesrc...
Nav_open_url: new url='http://reddit.com'
Dns_server [0]: reddit.com is 151.101.193.140 151.101.129.140 151.101.1.140 151.101.65.140
Connecting to 151.101.193.140:80
** ERROR **: [Dpi_read_comm_keys] No such file or directory
Dpi_blocking_start_dpid: try 1
[dpid]: a_Misc_mksecret: c8a6f211
dpid started
[cookies dpi]: Enabling cookies as per cookiesrc...
[cookies dpi]: Cookies loaded: 53.
[cookies dpi]: (v.1) accepting connections...
Nav_open_url: new url='https://reddit.com/'
Connecting to 151.101.193.140:443
reddit.com: TLSv1.3, cipher TLS_AES_128_GCM_SHA256
sha256 2048-bit RSA: /C=US/ST=California/L=SAN FRANCISCO/O=REDDIT, INC./CN=*.reddit.com
sha256 2048-bit RSA: /C=US/O=DigiCert Inc/CN=DigiCert TLS RSA SHA256 2020 CA1
root: /C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert Global Root CA
SSL_read() failed: SSL_get_error() returned 6
```