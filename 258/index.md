Title: Problems with png-config and fltk-config
Author: rodarima
Created: Wed, 11 Sep 2024 07:56:42 +0000
State: open

When installing FLTK in a different directory than /usr while keeping another installation there, I cannot link Dillo as it tries to find the libraries from /usr/lib due to a flag inserted by png-config:

```
g++ \
  -I/usr/include/libpng16 \
  -I/home/ram/dev/dillo/fltk/git/install/include \
  -D_LARGEFILE_SOURCE \
  -D_LARGEFILE64_SOURCE \
  -D_FILE_OFFSET_BITS=64 \
  -D_THREAD_SAFE \
  -D_REENTRANT \
  -g \
  -O2 \
  -Wall \
  -W \
  -Wno-unused-parameter \
  -fno-rtti \
  -fno-exceptions \
  -pedantic \
  -std=c++11 \
  -D_POSIX_C_SOURCE=200112L \
   \
   \
  -o \
  dillo \
  dillo.o \
  paths.o \
  tipwin.o \
  ui.o \
  uicmd.o \
  bw.o \
  cookies.o \
  hsts.o \
  auth.o \
  md5.o \
  digest.o \
  colors.o \
  misc.o \
  history.o \
  prefs.o \
  prefsparser.o \
  keys.o \
  url.o \
  bitvec.o \
  klist.o \
  chain.o \
  utf8.o \
  timeout.o \
  dialog.o \
  web.o \
  nav.o \
  cache.o \
  decode.o \
  dicache.o \
  capi.o \
  domain.o \
  css.o \
  cssparser.o \
  styleengine.o \
  plain.o \
  html.o \
  form.o \
  table.o \
  bookmark.o \
  dns.o \
  gif.o \
  jpeg.o \
  png.o \
  svg.o \
  imgbuf.o \
  image.o \
  menu.o \
  dpiapi.o \
  findbar.o \
  xembed.o \
  ../dlib/libDlib.a \
  ../dpip/libDpip.a \
  IO/libDiof.a \
  ../dw/libDw-widgets.a \
  ../dw/libDw-fltk.a \
  ../dw/libDw-core.a \
  ../lout/liblout.a \
  -ljpeg \
  -L/usr/lib \ <-------- here
  -lpng16 \
  -L/home/ram/dev/dillo/fltk/git/install/lib \
  -lfltk \
  -lm \
  -lpthread \
  -lXinerama \
  -lXfixes \
  -lXcursor \
  -L/usr/lib \
  -lpangoxft-1.0 \
  -lpangoft2-1.0 \
  -lpango-1.0 \
  -lgobject-2.0 \
  -lglib-2.0 \
  -lharfbuzz \
  -lfontconfig \
  -lfreetype \
  -lXft \
  -lpangocairo-1.0 \
  -lcairo \
  -lX11 \
  -lXrender \
  -lwayland-cursor \
  -lwayland-client \
  -lxkbcommon \
  -ldbus-1 \
  -ldecor-0 \
  -ldl \
  -lz \
  -liconv \
  -lpthread \
  -lX11 \
  -lcrypto \
  -lssl
```

Ideally we should either point to the whole path with -l or discover how to make -L only affect the corresponding -l library.

--%--
From: rodarima
Date: Wed, 11 Sep 2024 08:36:38 +0000

Tried `-Wl,--push-state` but it doesn't seem to affect `-L`.

--%--
From: rodarima
Date: Wed, 11 Sep 2024 09:02:07 +0000

We should let the users pass the FLTK and other flags manually, so we avoid the problem in which a injected `-L` from fltk-config or png-config affects the rest of the libraries.

--%--
From: rodarima
Date: Mon, 14 Apr 2025 17:55:18 +0000

Also, fltk-config is injecting its own -O2 flags, which will race with the optimization level for debugging.

--%--
From: rodarima
Date: Sun, 31 Aug 2025 22:44:30 +0000

There is another issue, if there is already an FLTK library installed in /usr/lib (or potentially /usr/local/lib) it can be loaded *instead* of the one dillo was linked against. We would need to add the corresponding `-Wl,-rpath,...` flags for the linker as well.

I think leaving the control of the variable to the use for non-standard installation is the best choice, so it can also inject platform or compiler specific flags.