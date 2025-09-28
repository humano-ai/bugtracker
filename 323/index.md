Title: Don't complain (on the console) about missing files which aren't necessary
Author: eyalroz
Created: Mon, 16 Dec 2024 21:04:46 +0000
State: closed

What running dillo (3.1.1), I get:
```
paths: Cannot open file '/home/eyalroz/.dillo/dillorc': No such file or directory
paths: Using /opt/dillo/etc/dillo/dillorc
paths: Cannot open file '/home/eyalroz/.dillo/keysrc': No such file or directory
paths: Using /opt/dillo/etc/dillo/keysrc
paths: Cannot open file '/home/eyalroz/.dillo/domainrc': No such file or directory
paths: Using /opt/dillo/etc/dillo/domainrc
Domain: Default accept.
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.3.2 3 Sep 2024
Disabling cookies.
paths: Cannot open file '/home/eyalroz/.dillo/hsts_preload': No such file or directory
```
Indeed, I don't have a `dillorc`, `keysrc`, or `domainrc`, and in fact no `.dillo`. But:

1. That's not an error, it's perfectly legitimate not to have them.
2. Dillo doesn't create them to force them into existence.

So - why report the files not being there as an error? And, in fact, why even try opening files in `~/.dillo` when it doesn't exist? Plus, you're already saying 
```
paths: Using /opt/dillo/etc/dillo/dillorc
paths: Using /opt/dillo/etc/dillo/keysrc
paths: Using /opt/dillo/etc/dillo/domainrc
```
is that not sufficient?

--%--
From: rodarima
Date: Tue, 17 Dec 2024 04:55:59 +0000

There is no error, knowing the reason we cannot use dillorc is useful.