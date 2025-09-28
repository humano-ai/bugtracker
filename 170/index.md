Title: Crash on Mac
Author: bouncepaw
Created: Wed, 15 May 2024 20:37:35 +0000
State: closed

1. Installed `dillo` via homebrew
2. Open dillo
3. Visit http://bouncepaw.com
4. Browser crashes

It's the same for HTTPS as well.

```
~ --> dillo -v
Dillo version 3.2.0
```

Mac version: Sonoma 14.4.1 (the most recent one, I think).

Terminal printout:

```
~ --> dillo
dillo_dns_init: Here we go! (threaded)
Failed to parse certificates from /etc/ssl/certs/ca-certificates.crt
Failed to parse certificates from /etc/pki/tls/certs/ca-bundle.crt
Failed to parse certificates from /usr/share/ssl/certs/ca-bundle.crt
Failed to parse certificates from /usr/local/share/certs/ca-root.crt
Loaded TLS certificates.
Disabling cookies.
** WARNING **: preferred sans-serif font "DejaVu Sans" not found.
** WARNING **: preferred serif font "DejaVu Serif" not found.
** WARNING **: preferred monospace font "DejaVu Sans Mono" not found.
** WARNING **: preferred cursive font "DejaVu Serif" not found.
** WARNING **: preferred fantasy font "DejaVu Sans" not found.
Nav_open_url: new url='about:splash'
2024-05-15 23:34:16.233 dillo[67618:2738233] TSM AdjustCapsLockLEDForKeyTransitionHandling - _ISSetPhysicalKeyboardCapsLockLED Inhibit
Nav_open_url: new url='http://bouncepaw.com'
Dns_server [0]: bouncepaw.com is 88.214.236.204
Connecting to 88.214.236.204:80
zsh: segmentation fault  dillo
```

```
~ --> dillo https://bouncepaw.com
dillo_dns_init: Here we go! (threaded)
Failed to parse certificates from /etc/ssl/certs/ca-certificates.crt
Failed to parse certificates from /etc/pki/tls/certs/ca-bundle.crt
Failed to parse certificates from /usr/share/ssl/certs/ca-bundle.crt
Failed to parse certificates from /usr/local/share/certs/ca-root.crt
Loaded TLS certificates.
Disabling cookies.
** WARNING **: preferred sans-serif font "DejaVu Sans" not found.
** WARNING **: preferred serif font "DejaVu Serif" not found.
** WARNING **: preferred monospace font "DejaVu Sans Mono" not found.
** WARNING **: preferred cursive font "DejaVu Serif" not found.
** WARNING **: preferred fantasy font "DejaVu Sans" not found.
Nav_open_url: new url='https://bouncepaw.com'
Dns_server [0]: bouncepaw.com is 88.214.236.204
Connecting to 88.214.236.204:443
bouncepaw.com TLSv1.3, cipher TLS_AES_256_GCM_SHA384
zsh: segmentation fault  dillo https://bouncepaw.com
```

--%--
From: rodarima
Date: Wed, 15 May 2024 20:44:53 +0000

Thanks for testing it, but I don't think that one is our Dillo, as the latest version is 3.1.0, and you should see the OpenSSL message on start. Check that you have this one: https://formulae.brew.sh/formula/dillo

Maybe you can use `which -a` to see where it is coming from.

I loaded your page just fine.

--%--
From: bouncepaw
Date: Wed, 15 May 2024 20:48:41 +0000

<img width="892" alt="Снимок экрана 2024-05-15 в 23 47 25" src="https://github.com/dillo-browser/dillo/assets/22562024/d29a221e-f9c2-4ee2-91c5-e81f57ffe1f4">

OK now we're talking! I indeed had a different Dillo installation. Thank you @rodarima! This Dillo works great, closing the issue.