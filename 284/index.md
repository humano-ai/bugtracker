Title: Crazy memory usage on paper with lots of SVG equations
Author: rodarima
Created: Fri, 18 Oct 2024 17:37:48 +0000
State: open

https://www.gutenberg.org/cache/epub/36276/pg36276-images.html

--%--
From: ghost
Date: Fri, 18 Oct 2024 21:53:04 +0000

Confirmed.

This page makes Dillo eventually exit on OpenBSD, but with no error or core dump.

Here is a log:

Nav_open_url: new url='https://www.gutenberg.org/cache/epub/36276/pg36276-images.html'
Dns_server [0]: www.gutenberg.org is 152.19.134.47
Connecting to 152.19.134.47:443
www.gutenberg.org: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha384 2048-bit RSA: /C=US/ST=Utah/O=Project Gutenberg Literary Archive Foundation/CN=*.gutenberg.org
** WARNING **: In 2015, browsers have begun to deprecate SHA1 certificates.
sha1 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
sha384 4096-bit RSA: /C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority
sha384 3072-bit RSA: /C=US/O=Network Solutions L.L.C./CN=Network Solutions RSA OV SSL CA 3
root: /C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority
** WARNING **: Svg_write: suspicious image size request 13860 x 3157
** WARNING **: Svg_write: suspicious image size request 23126 x 2862
** WARNING **: Svg_write: suspicious image size request 18688 x 4515
** WARNING **: Svg_write: suspicious image size request 26130 x 1457
** WARNING **: Svg_write: suspicious image size request 25814 x 2237
** WARNING **: Svg_write: suspicious image size request 22996 x 2429
** WARNING **: Svg_write: suspicious image size request 20241 x 2464
** WARNING **: Svg_write: suspicious image size request 18318 x 2252
** WARNING **: Svg_write: suspicious image size request 20462 x 2405
** WARNING **: Svg_write: suspicious image size request 22800 x 2416
** WARNING **: Svg_write: suspicious image size request 18689 x 2293
** WARNING **: Svg_write: suspicious image size request 16809 x 2242
** WARNING **: Svg_write: suspicious image size request 32013 x 2466
** WARNING **: Svg_write: suspicious image size request 17586 x 5080
** WARNING **: Svg_write: suspicious image size request 18218 x 4993
** WARNING **: Svg_write: suspicious image size request 24356 x 2374
** WARNING **: Svg_write: suspicious image size request 8570 x 5135
** WARNING **: Svg_write: suspicious image size request 27708 x 2261
** WARNING **: Svg_write: suspicious image size request 19614 x 2374
** WARNING **: Svg_write: suspicious image size request 17799 x 5080
** WARNING **: Svg_write: suspicious image size request 26582 x 11224
EXIT: 1