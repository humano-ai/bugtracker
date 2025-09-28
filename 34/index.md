Title: Support for Atari machines
Author: rodarima
Created: Sun, 24 Dec 2023 14:11:15 +0000
State: open

Following this thread:

https://www.atari-forum.com/viewtopic.php?t=43326

The folks at Atari Forum managed to get Dillo working on an Atari simulator:

![image](https://github.com/dillo-browser/dillo/assets/3866127/429b1250-b4fd-4254-b0ae-b08a5cedbf99)

I'm opening this issue to track the current status of the port and to see what changes we may need to add to Dillo and the build system to improve the support for this platform.

Some of the issues and quirks required are discussed in #33. Most of them are caused by the not great support for cross compilation.

Here is the that @th-otto provided to build it on this platform. It needs to cross-compile Dillo using the `m68k-atari-mint-g++` compiler:

```diff
diff --git a/configure.ac b/configure.ac
index 93747056..25ea5f65 100644
--- a/configure.ac
+++ b/configure.ac
@@ -148,10 +148,12 @@ dnl Check whether to add /usr/local or not
 dnl (this is somewhat a religious problem)
 dnl --------------------------------------
 dnl
+if test "$GCC" = no; then
 if test "`$CPP -v < /dev/null 2>&1 | grep '/usr/local/include' 2>&1`" = ""; then
   CPPFLAGS="$CPPFLAGS -I/usr/local/include"
   LDFLAGS="$LDFLAGS -L/usr/local/lib"
 fi
+fi
 
 dnl ------------------------------------
 dnl Check for socket libs (AIX, Solaris)
@@ -198,6 +200,7 @@ dnl Test for FLTK 1.3 library
 dnl -------------------------
 dnl
 dnl For debugging and to be user friendly
+if test "$cross_compiling" = no; then
 AC_PATH_PROG(FLTK_CONFIG,fltk-config)
 AC_MSG_CHECKING([FLTK 1.3])
 fltk_version="`$FLTK_CONFIG --version 2>/dev/null`"
@@ -211,6 +214,10 @@ case $fltk_version in
   *)     AC_MSG_RESULT(no)
          AC_MSG_ERROR(FLTK 1.3 required; fltk-config not found)
 esac
+else
+         AC_MSG_RESULT(assume yes)
+         LIBFLTK_LIBS="-lfltk"
+fi
 
 dnl -----------------------------------
 dnl Test for X11 (only on some systems)
@@ -221,20 +228,18 @@ old_libs=$LIBS
 old_cxxflags=$CXXFLAGS
 LIBS=$LIBFLTK_LIBS
 CXXFLAGS=$LIBFLTK_CXXFLAGS
-AC_RUN_IFELSE([AC_LANG_PROGRAM([[
+AC_LINK_IFELSE([AC_LANG_PROGRAM([[
 #define FL_INTERNALS
 #include <FL/x.H>
 ]],[[
 #ifdef X_PROTOCOL
    return 0;
 #else
-   return 1;
+   nope
 #endif
 ]])], [AC_MSG_RESULT(yes)
-       LIBX11_LIBS="-lX11"],
-      [AC_MSG_RESULT(no)],
-      [AC_MSG_RESULT(no)
-       AC_MSG_WARN([*** Test for X11 not possible when cross-compiling. ***])])
+       LIBX11_LIBS="-lXext -lX11"],
+      [AC_MSG_RESULT(no)])
 CXXFLAGS=$old_cxxflags
 LIBS=$old_libs
 AC_LANG_POP([C++])
@@ -292,68 +297,33 @@ dnl ---------------
 dnl Test for libpng
 dnl ---------------
 dnl
+PKG_PROG_PKG_CONFIG
 png_ok="no"
 if test "x$enable_png" = "xyes"; then
-  AC_MSG_CHECKING([for libpng-config])
-
-dnl Check if the user hasn't set the variable $PNG_CONFIG
-  if test -z "$PNG_CONFIG"; then
-    PNG_CONFIG=`which libpng16-config`
-    if test -z "$PNG_CONFIG"; then
-      PNG_CONFIG=`which libpng14-config`
-    fi
-    if test -z "$PNG_CONFIG"; then
-      PNG_CONFIG=`which libpng12-config`
-    fi
-    if test -z "$PNG_CONFIG"; then
-      PNG_CONFIG=`which libpng-config`
+  AC_MSG_CHECKING([for libpng])
+  for libpng in libpng libpng16 libpng14 libpng12 libpng10; do
+    if test "$png_ok" = "no"; then
+      PKG_CHECK_MODULES([LIBPNG], $libpng, [png_ok="yes"; png_version=`$PKG_CONFIG --modversion $libpng`])
     fi
-    if test -z "$PNG_CONFIG"; then
-      PNG_CONFIG=`which libpng10-config`
-    fi
-  fi
-
-dnl Check if the libpng-config script was found and is executable
-  if test -n "$PNG_CONFIG" && test -x "$PNG_CONFIG"; then
-    AC_MSG_RESULT([$PNG_CONFIG])
-    png_ok="yes"
-  else
-    AC_MSG_RESULT([missing])
-    png_ok="no"
-  fi
+  done
 
   if test "x$png_ok" = "xyes"; then
 dnl For debugging and to be user friendly
     AC_MSG_CHECKING([for libpng version])
-    png_version=`$PNG_CONFIG --version`
     case $png_version in
       1.[[0246]].*) AC_MSG_RESULT([$png_version]) ;;
                 *) AC_MSG_RESULT([$png_version (unrecognised version)]) ;;
     esac
 
-dnl Try to use options that are supported by all libpng-config versions...
-    LIBPNG_CFLAGS=`$PNG_CONFIG --cflags`
-    LIBPNG_LIBS=`$PNG_CONFIG --ldflags`
-    case $png_version in
-      1.2.4*) LIBPNG_LIBS="$LIBPNG_LIBS `$PNG_CONFIG --libs`" ;;
-    esac
-  else
-dnl Try to find libpng even though libpng-config wasn't found
-    AC_CHECK_HEADERS(png.h libpng/png.h, png_ok=yes && break, png_ok=no)
-
     if test "x$png_ok" = "xyes"; then
       old_libs="$LIBS"
-      AC_CHECK_LIB(png, png_sig_cmp, png_ok=yes, png_ok=no, $LIBZ_LIBS -lm)
+      AC_CHECK_LIB(png, png_sig_cmp, :, png_ok=no, $LIBPNG_LIBS $LIBZ_LIBS -lm)
       LIBS="$old_libs"
-
-      if test "x$png_ok" = "xyes"; then
-        LIBPNG_LIBS="-lpng -lm"
-      fi
     fi
 
-    if test "x$png_ok" = "xno"; then
-      AC_MSG_WARN([*** No libpng found. Disabling PNG images ***])
-    fi
+  fi
+  if test "x$png_ok" = "xno"; then
+    AC_MSG_WARN([*** No libpng found. Disabling PNG images ***])
   fi
 fi
 
@@ -375,13 +345,13 @@ tls_ok="no"
 tls_impl="none"
 if test "x$enable_tls" = "xyes"; then
   if test "x$enable_openssl" = "xyes"; then
-    dnl Search for OpenSSL headers first
-    AC_CHECK_HEADER(openssl/ssl.h, openssl_ok=yes, openssl_ok=no)
+    dnl Search for OpenSSL
+    PKG_CHECK_MODULES([LIBSSL], [openssl], openssl_ok=yes, openssl_ok=no)
 
     dnl If the headers are found, try to link with -lssl and -lcrypto
     if test "x$openssl_ok" = "xyes"; then
       old_libs="$LIBS"
-      AC_CHECK_LIB(ssl, SSL_write, openssl_ok=yes, openssl_ok=no, -lcrypto)
+      AC_CHECK_LIB(ssl, SSL_write, openssl_ok=yes, openssl_ok=no, $LIBSSL_LIBS)
       LIBS="$old_libs"
     fi
 
@@ -390,7 +360,6 @@ if test "x$enable_tls" = "xyes"; then
       AC_MSG_NOTICE([Using OpenSSL as TLS library.])
       tls_impl="OpenSSL"
       AC_DEFINE([HAVE_OPENSSL], [1], [OpenSSL works])
-      LIBSSL_LIBS="-lcrypto -lssl"
     else
       AC_MSG_NOTICE([Cannot find OpenSSL, trying mbedTLS...])
     fi
@@ -519,6 +488,10 @@ case $target in
     AC_MSG_NOTICE([Minix detected, skipping pthread detection])
     ;;
 
+  *-*-mint*)
+    AC_MSG_NOTICE([MiNT detected, skipping pthread detection])
+    ;;
+
   *)
     AC_MSG_CHECKING(whether threads work with -pthread)
     LDSAVEFLAGS=$LDFLAGS
diff --git a/dpi/Makefile.am b/dpi/Makefile.am
index 62b82e1b..4781c75f 100644
--- a/dpi/Makefile.am
+++ b/dpi/Makefile.am
@@ -1,6 +1,8 @@
 AM_CPPFLAGS = \
 	-I$(top_srcdir)
 
+LIBS = $(LIBX11_LIBS)
+
 bookmarksdir = $(libdir)/dillo/dpi/bookmarks
 downloadsdir = $(libdir)/dillo/dpi/downloads
 ftpdir = $(libdir)/dillo/dpi/ftp
diff --git a/src/IO/tls_openssl.c b/src/IO/tls_openssl.c
index d2a454e7..9d153a8f 100644
--- a/src/IO/tls_openssl.c
+++ b/src/IO/tls_openssl.c
@@ -491,7 +491,11 @@ static bool_t Tls_check_cert_strength(SSL *ssl, Server_t *srv, int *choice)
          if (print_chain)
             MSG("%s ", buf);
 
+#if OPENSSL_VERSION_NUMBER >= 0x30000000L
          key_type = EVP_PKEY_type(EVP_PKEY_get_id(public_key));
+#else
+         key_type = EVP_PKEY_type(EVP_PKEY_id(public_key));
+#endif
          type_str = key_type == EVP_PKEY_RSA ? "RSA" :
                     key_type == EVP_PKEY_DSA ? "DSA" :
                     key_type == EVP_PKEY_DH ? "DH" :
@@ -830,6 +834,7 @@ static int Tls_examine_certificate(SSL *ssl, Server_t *srv)
          ret = 0;
          break;
       case X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT:
+         { /* Case follows declaration */
          /* Either self signed and untrusted */
          /* Extract CN from certificate name information */
          X509_NAME *subject_name = X509_get_subject_name(remote_cert);
@@ -868,6 +873,7 @@ static int Tls_examine_certificate(SSL *ssl, Server_t *srv)
             default:
                break;
          }
+         }
          break;
       case X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT:
       case X509_V_ERR_UNABLE_TO_DECODE_ISSUER_PUBLIC_KEY:
```

--%--
From: rodarima
Date: Sun, 24 Dec 2023 14:18:53 +0000

I will continue the discussion here, as the other PR was for OpenSSL 1.1 support only.

> > Do you see any messages in the terminal?
> 
> There are no error messages, it just times out after some time with the message `Dns_server [0]: <hostname> is (nil)`
> 
> But seems to be a bit random. Sometimes it works. Maybe just a problem with my setup (using aranym with a bridge to the host), since sometimes other network connections also fail. I've always used --disable-threaded-dns, since the only thread implementation currently available is pth, and that is non-preemptive and just causes problems because of this.

That's strange, but if you report that other network connections fail maybe is not related with Dillo. 

> > Adding /usr/local/include is required in some BSD systems
> 
> I have disabled that currently when using gcc, since gcc should always look in that directories by default. Should that cause problems on BSD system, the test could also be changed to `if test "$cross_compiling" = no`
> 
> Other things that i changed: looking for png library uses png-config. I've tested it also on linux, but may need some testing for other systems.
> 
> For FLTK i currently just use -lfltk when cross-compiling, since it does not seem to require any special cflags. Maybe that test could also be changed to some `AC_CHECK_LIB`.
> 
> The dpi programs have to be linked explicitly to the x11 libraries. This is again only needed because of static libraries, but should not hurt on other systems.
> 
> Searching for openssl also uses pkg-config now. I have no mbedtls yet, so i don't know what files are installed there.
> 
> All in all the patches aren't that large, so if you don't want to apply them, i can just keep them as mint-specific patches.
> 
> But note that this is all quite experimental. There are other quirks currently, some drawing problems (which i suspect to be fVDI problems in combination with aranym), the tooltips sometimes immediately disappearing again etc. And of course that X.App that is needed is also quite experimental.

I think most of those patches can be included in Dillo. But I'll have to think a way to test it under CI, so I can avoid breaking it in the future. Maybe I can find a way to cross compile to ARM, which would exercise most of the cross compilation logic. Or I don't know how complicated is to setup the simulator for Atari.

> However the rendering always is quite strange, also in the linux version of dillo. Maybe some features of CSS that are not implemented yet?

Yeah, the support for CSS is not complete (yet).

> [dillo.patch.txt](https://github.com/dillo-browser/dillo/files/13761123/dillo.patch.txt)

Thanks for the patch!

--%--
From: th-otto
Date: Sun, 24 Dec 2023 18:27:49 +0000

> Or I don't know how complicated is to setup the simulator for Atari.

Well first thing you would need is aranym ;) Unforunately, currently snapshots are still not available since bintray closed, so you have to compile it yourself. But it is autotools based, so shouldn't be that hard.

For a working freemint environment, you should be able to use the snapshot builds of freemint: https://tho-otto.de/snapshots/freemint/bootable/

Getting network working is another thing though.

Precompiled libraries for fltk, openssl and everything else you might need are available at https://tho-otto.de/crossmint.php

--%--
From: rodarima
Date: Mon, 25 Dec 2023 14:05:57 +0000

> > Or I don't know how complicated is to setup the simulator for Atari.
> 
> Well first thing you would need is aranym ;) Unforunately, currently snapshots are still not available since bintray closed, so you have to compile it yourself. But it is autotools based, so shouldn't be that hard.

It seems to be available in the [AUR](https://aur.archlinux.org/packages/aranym) which builds it from:

http://downloads.sourceforge.net/sourceforge/aranym/aranym_1.1.0.orig.tar.gz

I'm guessing that may work (?). It asks for a ROM:

![aranym-os](https://github.com/dillo-browser/dillo/assets/3866127/1487fa22-262a-4f79-8814-03d5c2b88544)

![aranym](https://github.com/dillo-browser/dillo/assets/3866127/976d92c5-1678-418e-9eca-a1cfad57a46c)

> For a working freemint environment, you should be able to use the snapshot builds of freemint: https://tho-otto.de/snapshots/freemint/bootable/

Which file(s) do I need exactly? And can you specify how to invoke ARAnyM to load the ROM/images?

> Getting network working is another thing though.
> 
> Precompiled libraries for fltk, openssl and everything else you might need are available at https://tho-otto.de/crossmint.php

Okay, I'll try that eventually.

First, I'll try to setup a CI runner that does a cross compilation from x64 to something else (probably ARM) as that seems like an easier first step. Once that works, I see if I can try to boot ARAnyM myself and built it there.

--%--
From: rodarima
Date: Mon, 25 Dec 2023 14:20:45 +0000

Managed to get EmuTOS loading:

![aranym-emutos](https://github.com/dillo-browser/dillo/assets/3866127/cdfb1bac-f882-46e9-9b23-daca32c6f86c)

But no idea how to load FreeMiNT.

--%--
From: rodarima
Date: Mon, 25 Dec 2023 14:32:25 +0000

Managed to boot FreeMiNT and open a bash shell:

![freemint](https://github.com/dillo-browser/dillo/assets/3866127/fd60c3c6-43db-4c41-9c30-8a65e4fc60cb)


--%--
From: th-otto
Date: Mon, 25 Dec 2023 14:37:43 +0000

> It seems to be available in the [AUR](https://aur.archlinux.org/packages/aranym) which builds it from:
> I'm guessing that may work (?). It asks for a ROM:

That might work, but there haven't been any releases for a while. You can use it as a start, but eventually you should replace that later by a freshly compiled version from the source repo (https://github.com/aranym/aranym)

>Which file(s) do I need exactly? And can you specify how to invoke ARAnyM to load the ROM/images?

Seems you have figured that out already. You should specify EmuTOS as ROM in ``~/.aranym/config``
```
[GLOBAL]
EmuTOS = emutos-aranym.img
```

>Managed to boot FreeMiNT and open a bash shell:

Nice. Thats almost all you need. Easiest way to access other files is to map a host filesystem:
```
[HOSTFS]
H = ~/
```

(or some other dir)

Edit: You should make sure that important directories like /usr point to a filesystem that supports long filenames, otherwise you run into trouble with lots of unix programs. /usr is typically setup as a symlink in u:\usr (U:\ is the root filesystem for MiNT)


--%--
From: rodarima
Date: Mon, 25 Dec 2023 14:48:00 +0000

> > It seems to be available in the [AUR](https://aur.archlinux.org/packages/aranym) which builds it from:
> > I'm guessing that may work (?). It asks for a ROM:
> 
> That might work, but there haven't been any releases for a while. You can use it as a start, but eventually you should replace that later by a freshly compiled version from the source repo (https://github.com/aranym/aranym)

Okey, I'll adjust the PKGBUILD.

> > Which file(s) do I need exactly? And can you specify how to invoke ARAnyM to load the ROM/images?
> 
> Seems you have figured that out already. You should specify EmuTOS as ROM in `~/.aranym/config`
> 
> ```
> [GLOBAL]
> EmuTOS = emutos-aranym.img
> ```

I'm using the `runme.sh` insize `freemint-1-19-bc6492f7-040-aranym.zip`, `EmuTOS` is already set to that value.

> > Managed to boot FreeMiNT and open a bash shell:
> 
> Nice. Thats almost all you need. Easiest way to access other files is to map a host filesystem:
> 
> ```
> [HOSTFS]
> H = ~/
> ```
> 
> (or some other dir)
> 
> Edit: You should make sure that important directories like /usr point to a filesystem that supports long filenames, otherwise you run into trouble with lots of unix programs. /usr is typically setup as a symlink in u:\usr (U:\ is the root filesystem for MiNT)

So you cross-compile Dillo with dynamic libs and then you share the binary and dependencies inside the VM with the HOSTFS mounts?



--%--
From: th-otto
Date: Mon, 25 Dec 2023 16:42:06 +0000

There aren't any dynamic libs ;) But basically yes, i cross-compile dillo on linux, then switch to aranym, cd to the directory where i just compiled it on the host, and run it from there.

For the dip-programs, you can copy them inside aranym to the /usr/lib/dillo directory. But i think for a first test they are not needed.

But it seems it is not that easy to setup the X.app for atari correctly. See also the thread https://www.atari-forum.com/viewtopic.php?p=455548#p455548