Title: FreeBSD linker error due to undefined libiconv_open
Author: rodarima
Created: Wed, 27 Dec 2023 11:45:05 +0000
State: closed

```
c++ -I/usr/local/include/libpng16 -I/usr/local/include -I/usr/local/include \
  -I/usr/local/include/freetype2 -I/usr/local/include/libpng16 -D_THREAD_SAFE -O2 \
  -pipe -fstack-protector-strong -isystem /usr/local/include -fno-strict-aliasing \
  -isystem /usr/local/include -fvisibility-inlines-hidden -I/usr/local/include \
  -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_THREAD_SAFE \
  -D_REENTRANT -g -O2 -Wall -W -Wno-unused-parameter -fno-rtti \
  -fno-exceptions    -o dillo dillo.o paths.o tipwin.o  ui.o uicmd.o bw.o cookies.o  \
  hsts.o auth.o md5.o digest.o  colors.o misc.o history.o  prefs.o prefsparser.o \
  keys.o  url.o bitvec.o klist.o chain.o  utf8.o timeout.o dialog.o  web.o nav.o \
  cache.o decode.o  dicache.o capi.o domain.o  css.o cssparser.o styleengine.o \
  plain.o html.o form.o table.o  bookmark.o dns.o gif.o jpeg.o  png.o \
  imgbuf.o image.o menu.o  dpiapi.o findbar.o xembed.o ../dlib/libDlib.a \
  ../dpip/libDpip.a  IO/libDiof.a  ../dw/libDw-widgets.a  ../dw/libDw-fltk.a \
  ../dw/libDw-core.a  ../lout/liblout.a  -L/usr/local/lib -lpng16 -L/usr/local/lib \
  -lm -Wl,-rpath,/usr/local/lib -fstack-protector-strong -lfltk -lXrender -lXcursor \
  -lXfixes -lXext -lXft -lfontconfig -lXinerama -lpthread -lm -lX11 -lz  -lX11 \
  -lcrypto -lssl
  ld: error: undefined symbol: libiconv_open
  >>> referenced by form.cc:1142 (../../../src/form.cc:1142)
  >>>               form.o:(DilloHtmlForm::buildQueryData(DilloHtmlInput*))
  >>> referenced by form.cc:1146 (../../../src/form.cc:1146)
  >>>               form.o:(DilloHtmlForm::buildQueryData(DilloHtmlInput*))
  
  ld: error: undefined symbol: libiconv_close
  >>> referenced by form.cc:1244 (../../../src/form.cc:1244)
  >>>               form.o:(DilloHtmlForm::buildQueryData(DilloHtmlInput*))
  
  ld: error: undefined symbol: libiconv
  >>> referenced by form.cc:1339 (../../../src/form.cc:1339)
  >>>               form.o:(DilloHtmlForm::encodeText(void*, Dstr**))
  c++: error: linker command failed with exit code 1 (use -v to see invocation)
  *** Error code 1
  ```

This is likely caused by a the configure script first testing if iconv is provided by the libc, which it is:
```
  checking for iconv.h... yes
  checking for iconv_open in -lc... yes
```

But then, the `-isystem /usr/local/include` gets added from `fltk-config`, causing `/usr/local/include/iconv.h` to be loaded first which is part of libiconv (instead of `/usr/include/iconv.h`).

This header defines iconv_open() as libiconv_open() instead of the symbol iconv_open() provided by libc. Then, the linker fails as -liconv is not provided as initially it was decided to use the implementation in libc.

--%--
From: rodarima
Date: Wed, 27 Dec 2023 14:09:59 +0000

This doesn't make a lot of sense, as the form.o is compiled with a `-I/usr/include` first:
```
2023-12-27T12:38:34.1670839Z c++ -DHAVE_CONFIG_H -I. -I..   -I..  -DDILLO_SYSCONF='"/usr/local/etc/dillo/"'  -DDILLO_DOCDIR='"/usr/local/share/doc/dillo/"'  -DCUR_WORKING_DIR='"/home/runner/work/dillo/dillo/src"' -I/usr/include -I/usr/local/include/libpng16 -I/usr/local/include -I/usr/local/include -I/usr/local/include/freetype2 -I/usr/local/include/libpng16 -D_THREAD_SAFE -O2 -pipe -fstack-protector-strong -isystem /usr/local/include -fno-strict-aliasing -isystem /usr/local/include -fvisibility-inlines-hidden -I/usr/local/include -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_THREAD_SAFE -D_REENTRANT -g -O2 -Wall -W -Wno-unused-parameter -fno-rtti -fno-exceptions -MT form.o -MD -MP -MF .deps/form.Tpo -c -o form.o form.cc
```

Here is the `tr ' ' '\n'` version:

```
tr ' ' '\n' < /tmp/kk
2023-12-27T12:38:34.1670839Z
c++
-DHAVE_CONFIG_H
-I.
-I..


-I..

-DDILLO_SYSCONF='"/usr/local/etc/dillo/"'

-DDILLO_DOCDIR='"/usr/local/share/doc/dillo/"'

-DCUR_WORKING_DIR='"/home/runner/work/dillo/dillo/src"'
-I/usr/include
-I/usr/local/include/libpng16
-I/usr/local/include
-I/usr/local/include
-I/usr/local/include/freetype2
-I/usr/local/include/libpng16
-D_THREAD_SAFE
-O2
-pipe
-fstack-protector-strong
-isystem
/usr/local/include
-fno-strict-aliasing
-isystem
/usr/local/include
-fvisibility-inlines-hidden
-I/usr/local/include
-D_LARGEFILE_SOURCE
-D_LARGEFILE64_SOURCE
-D_THREAD_SAFE
-D_REENTRANT
-g
-O2
-Wall
-W
-Wno-unused-parameter
-fno-rtti
-fno-exceptions
-MT
form.o
-MD
-MP
-MF
.deps/form.Tpo
-c
-o
form.o
form.cc
```

--%--
From: rodarima
Date: Wed, 27 Dec 2023 14:23:27 +0000

Ah, this may be the problem, from gcc(1):

```
           If a standard system include directory, or a directory specified
           with -isystem, is also specified with -I, the -I option is ignored.
           The directory is still searched but as a system directory at its
           normal position in the system include chain.  This is to ensure
           that GCC's procedure to fix buggy system headers and the ordering
           for the "#include_next" directive are not inadvertently changed.
           If you really need to change the search order for system
           directories, use the -nostdinc and/or -isystem options.

```
So I'm guessing the first `-I/usr/include/` is ignored as it is already in the system list of gcc, then the `-isystem /usr/local/include` adds it to the beginning of the search list, and that ends up with `/usr/include/local/iconv.h`.

I can verify this by using `CXXFLAGS="-v"`, so it dumps the search path.

--%--
From: rodarima
Date: Wed, 27 Dec 2023 14:33:10 +0000

Yeah, that seems to be the case:
```
2023-12-27T14:28:38.9303858Z c++ -DHAVE_CONFIG_H -I. -I..   -I..  -DDILLO_SYSCONF='"/usr/local/etc/dillo/"'  -DDILLO_DOCDIR='"/usr/local/share/doc/dillo/"'  -DCUR_WORKING_DIR='"/home/runner/work/dillo/dillo/src"'  -I/usr/local/include/libpng16 -I/usr/local/include -I/usr/local/include -I/usr/local/include/freetype2 -I/usr/local/include/libpng16 -D_THREAD_SAFE -O2 -pipe -fstack-protector-strong -isystem /usr/local/include -fno-strict-aliasing -isystem /usr/local/include -fvisibility-inlines-hidden -I/usr/local/include -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_THREAD_SAFE -D_REENTRANT -I/START -I/usr/include -v -I/END -Wall -W -Wno-unused-parameter -fno-rtti -fno-exceptions -MT form.o -MD -MP -MF .deps/form.Tpo -c -o form.o form.cc
2023-12-27T14:28:38.9336368Z FreeBSD clang version 16.0.6 (https://github.com/llvm/llvm-project.git llvmorg-16.0.6-0-g7cbf1a259152)
2023-12-27T14:28:38.9337563Z Target: x86_64-unknown-freebsd14.0
2023-12-27T14:28:38.9338145Z Thread model: posix
2023-12-27T14:28:38.9338543Z InstalledDir: /usr/bin
2023-12-27T14:28:38.9340781Z  (in-process)
2023-12-27T14:28:38.9354557Z  "/usr/bin/c++" -cc1 -triple x86_64-unknown-freebsd14.0 -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name form.cc -mrelocation-model static -mframe-pointer=all -relaxed-aliasing -ffp-contract=on -fno-rounding-math -mconstructor-aliases -funwind-tables=2 -target-cpu x86-64 -tune-cpu generic -mllvm -treat-scalable-fixed-error-as-warning -debugger-tuning=gdb -v -fcoverage-compilation-dir=/home/runner/work/dillo/dillo/src -resource-dir /usr/lib/clang/16 -dependency-file .deps/form.Tpo -MT form.o -sys-header-deps -MP -isystem /usr/local/include -isystem /usr/local/include -D HAVE_CONFIG_H -I . -I .. -I .. -D "DILLO_SYSCONF=\"/usr/local/etc/dillo/\"" -D "DILLO_DOCDIR=\"/usr/local/share/doc/dillo/\"" -D "CUR_WORKING_DIR=\"/home/runner/work/dillo/dillo/src\"" -I /usr/local/include/libpng16 -I /usr/local/include -I /usr/local/include -I /usr/local/include/freetype2 -I /usr/local/include/libpng16 -D _THREAD_SAFE -I /usr/local/include -D _LARGEFILE_SOURCE -D _LARGEFILE64_SOURCE -D _THREAD_SAFE -D _REENTRANT -I /START -I /usr/include -I /END -internal-isystem /usr/include/c++/v1 -internal-isystem /usr/lib/clang/16/include -internal-externc-isystem /usr/include -O2 -Wall -W -Wno-unused-parameter -fdeprecated-macro -fdebug-compilation-dir=/home/runner/work/dillo/dillo/src -ferror-limit 19 -fvisibility-inlines-hidden -stack-protector 2 -fno-rtti -fgnuc-version=4.2.1 -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o form.o -x c++ form.cc
2023-12-27T14:28:38.9362257Z clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-unknown-freebsd14.0
2023-12-27T14:28:38.9362822Z ignoring nonexistent directory "/START"
2023-12-27T14:28:38.9363183Z ignoring nonexistent directory "/END"
2023-12-27T14:28:38.9363521Z ignoring duplicate directory ".."
2023-12-27T14:28:38.9363873Z ignoring duplicate directory "/usr/local/include"
2023-12-27T14:28:38.9364326Z ignoring duplicate directory "/usr/local/include/libpng16"
2023-12-27T14:28:38.9364776Z ignoring duplicate directory "/usr/local/include"
2023-12-27T14:28:38.9365176Z ignoring duplicate directory "/usr/local/include"
2023-12-27T14:28:38.9365733Z   as it is a non-system directory that duplicates a system directory
2023-12-27T14:28:38.9366223Z ignoring duplicate directory "/usr/local/include"
2023-12-27T14:28:38.9366846Z ignoring duplicate directory "/usr/include" <--- here
2023-12-27T14:28:38.9367378Z   as it is a non-system directory that duplicates a system directory <--- here
2023-12-27T14:28:38.9367828Z #include "..." search starts here:
2023-12-27T14:28:38.9368135Z #include <...> search starts here:
2023-12-27T14:28:38.9368422Z  .
2023-12-27T14:28:38.9368601Z  ..
2023-12-27T14:28:38.9368803Z  /usr/local/include/libpng16
2023-12-27T14:28:38.9369087Z  /usr/local/include/freetype2
2023-12-27T14:28:38.9369549Z  /usr/local/include
2023-12-27T14:28:38.9369787Z  /usr/include/c++/v1
2023-12-27T14:28:38.9370032Z  /usr/lib/clang/16/include
2023-12-27T14:28:38.9370287Z  /usr/include
2023-12-27T14:28:38.9370498Z End of search list.
```

I don't see any easy solution, as including `/usr/local/include` is required for the libraries in ports, so they will always shadow `/usr/include/iconv.h`. Maybe FreeBSD folks can suggest some solution...

--%--
From: rodarima
Date: Wed, 27 Dec 2023 17:09:47 +0000

Opened ticket in FreeBSD: https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=275969

--%--
From: idatum
Date: Sun, 05 May 2024 16:04:36 +0000

Seeing the same on NetBSD 10 (Aarch64):

`/work/dillo/build/src/../../src/form.cc:1339: undefined reference to `libiconv'
/work/dillo/build/src/../../src/form.cc:1339:(.text+0x148): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `libiconv'
ld: form.o: in function `DilloHtmlForm::buildQueryData(DilloHtmlInput*)':
/work/dillo/build/src/../../src/form.cc:1244: undefined reference to `libiconv_close'
/work/dillo/build/src/../../src/form.cc:1244:(.text+0x3c7c): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `libiconv_close'
ld: /work/dillo/build/src/../../src/form.cc:1142: undefined reference to `libiconv_open'
/work/dillo/build/src/../../src/form.cc:1142:(.text+0x4190): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `libiconv_open'
ld: /work/dillo/build/src/../../src/form.cc:1146: undefined reference to `libiconv_open'
/work/dillo/build/src/../../src/form.cc:1146:(.text+0x4260): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `libiconv_open'`