Title: SSL routines::unexpected eof while reading
Author: rodarima
Created: Fri, 18 Oct 2024 18:18:31 +0000
State: open

EU page doesn't load due TLS errors https://ec.europa.eu/commission/presscorner/detail/en/ip_24_4761:

```
% dillo https://ec.europa.eu/commission/presscorner/detail/en/ip_24_4761
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.3.2 3 Sep 2024
Enabling cookies as from cookiesrc...
Nav_open_url: new url='https://ec.europa.eu/commission/presscorner/detail/en/ip_24_4761'
Dns_server [0]: ec.europa.eu is 147.67.34.30 147.67.210.30
Connecting to 147.67.34.30:443
ec.europa.eu: TLSv1.3, cipher TLS_AES_128_GCM_SHA256
sha256 2048-bit RSA: /C=BE/ST=Brussels-Capital Region/L=Brussels/O=European Commission/CN=*.ec.europa.eu
sha256 2048-bit RSA: /C=BE/O=GlobalSign nv-sa/CN=GlobalSign RSA OV SSL CA 2018
root: /OU=GlobalSign Root CA - R3/O=GlobalSign/CN=GlobalSign
TLS ALERT on write: decode error
SSL_read() failed: error:0A000126:SSL routines::unexpected eof while reading
NumPendingStyleSheets=1
Tls_close_by_key: Avoiding SSL shutdown for: https://ec.europa.eu/commission/presscorner/detail/en/ip_24_4761
Premature close for https://ec.europa.eu/commission/presscorner/detail/en/ip_24_4761
TLS ALERT on write: decode error
SSL_read() failed: error:0A000126:SSL routines::unexpected eof while reading
Tls_close_by_key: Avoiding SSL shutdown for: https://ec.europa.eu/commission/presscorner/styles-6R54LL4T.css
Premature close for https://ec.europa.eu/commission/presscorner/styles-6R54LL4T.css
>>>> a_Nav_repush <<<<
Nav_open_url: new url='https://ec.europa.eu/commission/presscorner/detail/en/ip_24_4761'
a_Nav_expect_done: repush!
```

--%--
From: rodarima
Date: Sat, 19 Oct 2024 17:04:31 +0000

The page *does* load, just that nothing is displayed unless JS is enabled.

![eu](https://github.com/user-attachments/assets/d7f1b843-8a2e-465f-a421-d6c072714291)


--%--
From: rodarima
Date: Sun, 02 Mar 2025 19:47:32 +0000

Interestingly, loading the CSS of the page directly causes at least 15 seconds of UI locked at 100% CPU while wrapping the paragraph of the 500_000 characters long single line:

```
% dillo https://ec.europa.eu/commission/presscorner/styles-PDEFUULV.css
```

What a goldmine of problems in a single website.

Here is a more stable reproducer:

```
% dillo -l https://ec.europa.eu/commission/presscorner/
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.4.1 11 Feb 2025
Enabling cookies as from cookiesrc...
Nav_open_url: new url='https://ec.europa.eu/commission/presscorner/'
Dns_server [0]: ec.europa.eu is 147.67.210.30 147.67.34.30
Connecting to 147.67.210.30:443
ec.europa.eu: TLSv1.3, cipher TLS_AES_128_GCM_SHA256
sha256 2048-bit RSA: /C=BE/ST=Brussels-Capital Region/L=Brussels/O=European Commission/CN=*.ec.europa.eu
sha256 2048-bit RSA: /C=BE/O=GlobalSign nv-sa/CN=GlobalSign RSA OV SSL CA 2018
root: /OU=GlobalSign Root CA - R3/O=GlobalSign/CN=GlobalSign
TLS ALERT on write: decode error
SSL_read() failed: error:0A000126:SSL routines::unexpected eof while reading
Tls_close_by_key: Avoiding SSL shutdown for: https://ec.europa.eu/commission/presscorner/
Premature close for https://ec.europa.eu/commission/presscorner/
```