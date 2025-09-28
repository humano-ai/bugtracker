Title: mbedtls/net.h: No such file or directory
Author: rodarima
Created: Fri, 02 Jun 2023 11:28:34 +0000
State: closed

The mbedtls library has upgraded the API to the version 3 and no longer provides `mbedtls/net.h`:

```
../../../src/IO/tls.c:52:10: fatal error: mbedtls/net.h: No such file or
directory
   52 | #include <mbedtls/net.h>    /* net_send, net_recv */
```

However dillo is taking the headers from mbedtls 3 instead of from the 2:

```
% pacman -Ql mbedtls | grep net.h
% pacman -Ql mbedtls2 | grep net.h
mbedtls2 /usr/include/mbedtls2/mbedtls/net.h
```

--%--
From: rodarima
Date: Sun, 17 Dec 2023 19:19:03 +0000

The problem with mbedtls is that they have the version 2 and 3, which are both maintained at the same time, but the version 3 is missing in some distros. In Arch Linux is available and is causing confusion to the configure script.

Ideally we should be able to build it with any of the version 2 or 3, but so far I was unable to setup the CI to test the version 3.

--%--
From: rodarima
Date: Fri, 22 Dec 2023 20:19:28 +0000

Fixed in #27. For Arch Linux, if no other configure option is given it will link with OpenSSL by default. Otherwise, with `--disable-openssl` will attempt to link with mbedTLS 3.

If for any reason we need to link with mbedTLS 2 in Arch (not recommended), we need to specify the include and library paths with:
```
$ ./configure --disable-openssl CFLAGS='-I/usr/include/mbedtls2 -L/usr/lib/mbedtls2' CXXFLAGS='-I/usr/include/mbedtls2 -L/usr/lib/mbedtls2'
...

Configuration summary:

  CXX     : g++
  CXXFLAGS: -I/usr/include/mbedtls2 -L/usr/lib/mbedtls2 -Wall -W -Wno-unused-parameter -fno-rtti -fno-exceptions

  TLS enabled: yes
  TLS library: mbedTLS
  TLS flags  : -lmbedtls -lmbedx509 -lmbedcrypto

  Cookies enabled: yes
  XEmbed enabled : yes
  RTFL enabled   : no
  JPEG enabled   : yes
  PNG enabled    : yes
  GIF enabled    : yes

$ make
...
$ ldd src/dillo | grep mbed
	libmbedtls.so.14 => /usr/lib/libmbedtls.so.14 (0x00007f1f31ab5000)
	libmbedx509.so.1 => /usr/lib/libmbedx509.so.1 (0x00007f1f31a93000)
	libmbedcrypto.so.7 => /usr/lib/libmbedcrypto.so.7 (0x00007f1f31a1b000)

$ ls -l /usr/lib/mbedtls2/
total 0
lrwxrwxrwx 1 root root 21 Nov 20 14:55 libmbedcrypto.so -> ../libmbedcrypto.so.7
lrwxrwxrwx 1 root root 19 Nov 20 14:55 libmbedtls.so -> ../libmbedtls.so.14
lrwxrwxrwx 1 root root 19 Nov 20 14:55 libmbedx509.so -> ../libmbedx509.so.1
```