Title: [3.2.0] HTML Tests: FAIL: render/svg-current-color.html
Author: Kangie
Created: Thu, 30 Jan 2025 01:14:06 +0000
State: closed

When configured with 

```
 ./configure --prefix=/usr --build=x86_64-pc-linux-gnu --host=x86_64-pc-linux-gnu --mandir=/usr/share/man --infodir=/usr/share/info --datadir=/usr/share --sysconfdir=/etc --localstatedir=/var/lib --datarootdir=/usr/share --disable-dependency-tracking --disable-silent-rules --docdir=/usr/share/doc/dillo-3.2.0 --htmldir=/usr/share/doc/dillo-3.2.0/html --libdir=/usr/lib64 --disable-rtfl --enable-gif --enable-jpeg --disable-mbedtls --enable-openssl --enable-png --enable-tls --enable-svg --enable-xembed --enable-ipv6 --enable-html-tests=yes
```

I am unable to successfully complete the test suite on Gentoo Linux in either the 3.2.0 tarball or a clean checkout of master (0c7e087fbd0278da9a39bd16ab9385073f1f495c) due to 

```
FAIL: render/svg-current-color.html
```

Given that SVG support is vendored I'm not sure that there's much that I can do here.

Any suggestions?

[build.log.txt](https://github.com/user-attachments/files/18596098/build.log.txt) from a Gentoo Portage build, but I see the same (without `/dev/dri/card0` warnings) building from git sources manually.

--%--
From: rodarima
Date: Tue, 04 Feb 2025 18:28:19 +0000

> Any suggestions?

Disable the HTML rendering tests, they are not designed to be run outside the CI environment.