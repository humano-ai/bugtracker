Title: Add options to search custom MbedTLS installations
Author: winterheart
Created: Sat, 28 Jun 2025 13:34:07 +0000
State: closed

Some Linux distributions (like Gentoo or Arch) allows to install MbedTLS 2.x and 3.x branches simultaneously. This change helps to inding custom MbedTLS locations.

--%--
From: rodarima
Date: Wed, 02 Jul 2025 18:23:16 +0000

I have pushed a commit that works in Arch Linux for Mbed TLS 2:

```
% ../configure --disable-openssl --with-mbedtls-lib=/usr/lib/mbedtls2 --with-mbedtls-inc=/usr/include/mbedtls2
% ldd src/dillo | grep libmbedtls
	libmbedtls.so.14 => /usr/lib/libmbedtls.so.14 (0x00007f346b65f000)
% ls -l /usr/lib/mbedtls2/libmbedtls.so
lrwxrwxrwx 1 root root 19 Apr  6 14:40 /usr/lib/mbedtls2/libmbedtls.so -> ../libmbedtls.so.14
% ls -l /usr/lib/libmbedtls.so.[0-9]?
lrwxrwxrwx 1 root root 21 Apr  6 14:40 /usr/lib/libmbedtls.so.14 -> libmbedtls.so.2.28.10
lrwxrwxrwx 1 root root 19 Apr  6 06:26 /usr/lib/libmbedtls.so.21 -> libmbedtls.so.3.6.3
```

And for Mbed TLS 3 (no need for extra flags):

```
% ../configure --disable-openssl
% ldd src/dillo | grep libmbedtls
	libmbedtls.so.21 => /usr/lib/libmbedtls.so.21 (0x00007f488d3df000)
% ls -l /usr/lib/libmbedtls.so.[0-9]?
lrwxrwxrwx 1 root root 21 Apr  6 14:40 /usr/lib/libmbedtls.so.14 -> libmbedtls.so.2.28.10
lrwxrwxrwx 1 root root 19 Apr  6 06:26 /usr/lib/libmbedtls.so.21 -> libmbedtls.so.3.6.3
```

Let me know if that would fix it for Gentoo.

--%--
From: winterheart
Date: Wed, 02 Jul 2025 18:40:36 +0000

Building works in Gentoo with configure options:
```
./configure --disable-openssl --enable-tls --with-mbedtls-inc=/usr/include/mbedtls3
...
  TLS enabled: yes
  TLS library: mbedTLS
  TLS flags  : -lmbedtls-3 -lmbedcrypto-3 -lmbedx509-3
```

--%--
From: rodarima
Date: Wed, 02 Jul 2025 18:56:57 +0000

Perfect, then we can merge this if there are no futher issues.