Title: Allow image formats to be disabled from dillorc
Author: rodarima
Created: Sun, 08 Dec 2024 15:40:31 +0000
State: closed

Makes disabling certain formats posible without the need to rebuild Dillo from source.

See: https://github.com/dillo-browser/dillo/pull/312

--%--
From: rodarima
Date: Sun, 08 Dec 2024 15:42:37 +0000

@xlex8 could you take a look at this PR?

--%--
From: ghost
Date: Sun, 08 Dec 2024 18:26:14 +0000

This branch is not compiling here:
...
c++ -DHAVE_CONFIG_H -I. -I..  -I.. -DDILLO_SYSCONF='"/usr/local/etc/dillo/"' -DDILLO_DOCDIR='"/usr/local/share/doc/dillo/"' -I/usr/local/include -I/usr/X11R6/include -I/usr/local/include/libpng16 -I/usr/local/include -I/usr/X11R6/include/freetype2 -O2 -pipe -I/usr/local/include -fvisibility-inlines-hidden -I/usr/X11R6/include -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_THREAD_SAFE -D_REENTRANT -I/usr/X11R6/lib -Wall -W -Wno-unused-parameter -fno-rtti -fno-exceptions -pedantic -std=c++11 -D_POSIX_C_SOURCE=200112L -MT tipwin.o -MD -MP -MF .deps/tipwin.Tpo -c -o tipwin.o tipwin.cc
version.cc:40:25: error: no member named 'api_version' in 'Fl'
      int fltkver = Fl::api_version();
                    ~~~~^
1 error generated.


--%--
From: rodarima
Date: Sun, 08 Dec 2024 18:36:18 +0000

> version.cc:40:25: error: no member named 'api_version' in 'Fl'

Which FLTK version are you using? The method should be available on 1.3.X:

https://www.fltk.org/doc-1.3/classFl.html#a7600b0ef3dcd4311850ab4b2988d5d6d

--%--
From: ghost
Date: Sun, 08 Dec 2024 18:53:15 +0000

Stock FLTK 1.3.3 here. Just did a new build of master with no errors, and also some older checkouts, so it seems to be a recent change.

--%--
From: rodarima
Date: Sun, 08 Dec 2024 19:05:37 +0000

> Stock FLTK 1.3.3 here. Just did a new build of master with no errors, and also some older checkouts, so it seems to be a recent change.

Right, on 1.3.3 it was not available yet, I need to use Fl::version() instead.

https://github.com/fltk/fltk/blob/release-1.3.3/src/Fl.cxx#L135C1-L135C12

Let me do a quick patch so it builds for you too.

--%--
From: rodarima
Date: Sun, 08 Dec 2024 19:16:01 +0000

Should be fixed in https://github.com/dillo-browser/dillo/pull/316/commits/486cdad55097d5ffd8128c28c9952bac0854ac95

--%--
From: ghost
Date: Sun, 08 Dec 2024 19:45:17 +0000

Thanks, this PR appears to be working fine now!