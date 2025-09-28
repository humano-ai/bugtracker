Title: Add support for OpenSSL 1.1
Author: rodarima
Created: Sat, 23 Dec 2023 14:25:39 +0000
State: closed

The function is not available in OpenSSL 1.1 with the `_get` suffix.

--%--
From: rodarima
Date: Sat, 23 Dec 2023 14:26:53 +0000

Can you test it works with OpenSSL 1.1, @th-otto ?

--%--
From: th-otto
Date: Sat, 23 Dec 2023 16:24:02 +0000

I cannot test it on linux anymore, because i cannot simultaneously install development packages for both openssl 1.1.0 and openssl-3, because they conflict with each other.

Your patch is not yet merged, so i had to apply it manually. But i get other error, when trying to cross-compile for mint (with openssl 1.1.1 libraries installed)
(have to specifiy LIBS=-lz when running the configure script, because of all libraries being static only):
```
$ PKG_CONFIG_PATH=/usr/m68k-atari-mint/lib/pkgconfig ./configure LIBS="-lz" --disable-threads --prefix=/usr --host=m68k-atari-mint
...
Configuration summary:

  CXX     : m68k-atari-mint-g++
  CXXFLAGS: -g -O2 -Wall -W -Wno-unused-parameter -fno-rtti -fno-exceptions

  TLS enabled: yes
  TLS library: OpenSSL
  TLS flags  : -lcrypto -lssl

  Cookies enabled: yes
  XEmbed enabled : yes
  RTFL enabled   : no
  JPEG enabled   : yes
  PNG enabled    : yes
  GIF enabled    : yes

$ make

m68k-atari-mint-gcc -DHAVE_CONFIG_H -I. -I../..  -I../.. -DDILLO_BINDIR='"/usr/bin/"' -DCA_CERTS_FILE='""' m68k-atari-mint-gcc -DHAVE_CONFIG_H -I. -I../..  -I../.. -DDILLO_BINDIR='"/usr/bin/"' -DCA_CERTS_FILE='""' -DCA_CERTS_DIR='""' -I/usr/local/include  -g -O2 -DD_DNS_THREADED -D_REENTRANT -D_THREAD_SAFE -Wall -W -Wno-unused-parameter -Waggregate-return -MT tls_openssl.o -MD -MP -MF .deps/tls_openssl.Tpo -c -o tls_openssl.o tls_openssl.c
tls_openssl.c: In function 'Tls_examine_certificate':
tls_openssl.c:839:10: error: a label can only be part of a statement and a declaration is not a statement
          X509_NAME *subject_name = X509_get_subject_name(remote_cert);
          ^~~~~~~~~
tls_openssl.c:840:10: error: expected expression before 'char'
          char *subj = X509_NAME_oneline(subject_name, NULL, 0);
          ^~~~
tls_openssl.c:841:27: error: 'subj' undeclared (first use in this function)
          if ((cn = strstr(subj, "/CN=")) == NULL) {
                           ^~~~
tls_openssl.c:841:27: note: each undeclared identifier is reported only once for each function it appears in
tls_openssl.c:839:21: warning: unused variable 'subject_name' [-Wunused-variable]
          X509_NAME *subject_name = X509_get_subject_name(remote_cert);
                     ^~~~~~~~~~~~
```

Although it does not seem to cause problems for this particular case, the ``-I/usr/local/include`` does not belong there when cross-compiling (maybe that slipped in from checking for the X11-libraries? did not check yet)

Compiler is gcc-7.5.0


--%--
From: rodarima
Date: Sat, 23 Dec 2023 17:01:05 +0000

> Your patch is not yet merged, so i had to apply it manually.

I'll wait until I can setup some automatic tests for OpenSSL 1.1 before merging this.

> ```
> m68k-atari-mint-gcc -DHAVE_CONFIG_H -I. -I../..  -I../.. -DDILLO_BINDIR='"/usr/bin/"' -DCA_CERTS_FILE='""' m68k-atari-mint-gcc -DHAVE_CONFIG_H -I. -I../..  -I../.. -DDILLO_BINDIR='"/usr/bin/"' -DCA_CERTS_FILE='""' -DCA_CERTS_DIR='""' -I/usr/local/include  -g -O2 -DD_DNS_THREADED -D_REENTRANT -D_THREAD_SAFE -Wall -W -Wno-unused-parameter -Waggregate-return -MT tls_openssl.o -MD -MP -MF .deps/tls_openssl.Tpo -c -o tls_openssl.o tls_openssl.c
> tls_openssl.c: In function 'Tls_examine_certificate':
> tls_openssl.c:839:10: error: a label can only be part of a statement and a declaration is not a statement
>           X509_NAME *subject_name = X509_get_subject_name(remote_cert);
>           ^~~~~~~~~
> ```

I cannot reproduce this in any of my setups, but it is indeed an error. I pushed a tentative fix.

> Although it does not seem to cause problems for this particular case, the `-I/usr/local/include` does not belong there when cross-compiling (maybe that slipped in from checking for the X11-libraries? did not check yet)

This is likely caused by either `$CPP -v` reporting the directory to be used (see [configure.ac](https://github.com/dillo-browser/dillo/blob/80732c652e923981c43a730c2704e1c6876bd3e6/configure.ac#L151-L154)), or by `fltk-config --cxxflags` if installed in /usr/local.

As a workaround if your cross-compiler doesn't outputs "/usr/local/include" you can add `CPP=m68k-atari-mint-g++` to the configure line. Otherwise, just remove or comment the configure.ac part in which the include is added.

For `fltk-config` I don't have a solution yet, maybe adding something like this after the detection of the [FLTK flags in configure.ac](https://github.com/dillo-browser/dillo/blob/80732c652e923981c43a730c2704e1c6876bd3e6/configure.ac#L203-L213):

```
LIBFLTK_CFLAGS=`echo $LIBFLTK_CFLAGS | tr '-I/usr/local/include' ' '`
LIBFLTK_CXXFLAGS=`echo $LIBFLTK_CXXFLAGS | tr '-I/usr/local/include' ' '`
```

--%--
From: th-otto
Date: Sat, 23 Dec 2023 17:36:27 +0000

> I cannot reproduce this in any of my setups, but it is indeed an error. I pushed a tentative fix.

Yes, strangely gcc-13 seems to accept this, although it is clearly an error, atleast in non-C++ code. Your workaround fixed this.
 
> This is likely caused by either `$CPP -v` reporting the directory to be used (see [configure.ac](https://github.com/dillo-browser/dillo/blob/80732c652e923981c43a730c2704e1c6876bd3e6/configure.ac#L151-L154)), or by `fltk-config --cxxflags` if installed in /usr/local.

Maybe, i have to check that. If configure.ac invokes fltk-config, that may indeed be a problem when cross-compiling.
Unfortunately FLTK does not seem to install a pkg-config script. In the meantime, i think it would be best to force the user to specify the FLTK_CFLAGS & LIBS when cross-compiling.

However, the -I/usr/local/include does not seem to come from the fltk-config script, they are part of $CPPFLAGS (although i specified --prefix=/usr). Same for LDFLAGS: they are set to -L/usr/lib. That will even be wrong when compiling natively (eg. on openSUSE, fedora and others, 64-bit libraries are installed in /usr/lib64, and linking with -L/usr/lib wil give a warning atleast from the linker about incompatible libraries).

For further tests, i need cross-compiled FLTK libraries first.


--%--
From: th-otto
Date: Sat, 23 Dec 2023 19:33:26 +0000

After fiddling with configure.ac (for X11 libs, and also for libpng), i can confirm that building with openssl 1.1.1 works:

![Screenshot_20231223_202916](https://github.com/dillo-browser/dillo/assets/12425871/cf28eae0-3485-447d-a053-022e954a7d36)

Only dns lookups do not seem to work yet (maybe same problem that medmed had). But it does not completely freeze, it times out after about a 1-2 min.


--%--
From: rodarima
Date: Sat, 23 Dec 2023 19:50:31 +0000


> After fiddling with configure.ac (for X11 libs, and also for libpng), i can confirm that building with openssl 1.1.1 works:

Amazing :-)

> 
> Only dns lookups do not seem to work yet (maybe same problem that medmed had). But it does not completely freeze, it times out after about a 1-2 min.

Do you see any messages in the terminal? As a quick test, you could try to disable the threaded DNS resolver by using `--disable-threaded-dns` in case that could be affecting you as it was [causing problems in BSD](https://github.com/dillo-browser/dillo/blob/master/doc/install.md#bsd).

Can you resolve other hosts from the machine?, does `curl -v google.com`? If you don't have Curl, here is a test you can try with the OpenSSL CLI (which you may already have available):
```
$ echo | openssl s_client -showcerts -connect google.com:443
```

--%--
From: rodarima
Date: Sat, 23 Dec 2023 20:07:55 +0000

> After fiddling with configure.ac (for X11 libs, and also for libpng)

Also, can you share your patch/changes?, so I can also understand which parts are not working properly.

> Maybe, i have to check that. If configure.ac invokes fltk-config, that may indeed be a problem when cross-compiling.
> Unfortunately FLTK does not seem to install a pkg-config script. In the meantime, i think it would be best to force the user to specify the FLTK_CFLAGS & LIBS when cross-compiling.

That solution sounds good to me, in case you want to make a MR :-)

> However, the -I/usr/local/include does not seem to come from the fltk-config script, they are part of $CPPFLAGS (although i specified --prefix=/usr).

Then, it is likely to be coming from the `CPP` variable, (notice `CC != CXX != CPP`). You can comment or remove those lines from the `configure.ac` if they cause you any trouble.

Adding `/usr/local/include` is required in some BSD systems, as they install some headers/libs there (from ports). This also breaks BSD builds in other obscure ways (like using a header from `/usr/include/local` but linking with the library in `/usr/lib`), so we would need to find a better solution anyway.

--%--
From: th-otto
Date: Sun, 24 Dec 2023 10:09:35 +0000

> Do you see any messages in the terminal?

There are no error messages, it just times out after some time with the message
``Dns_server [0]: <hostname> is (nil)``

But seems to be a bit random. Sometimes it works. Maybe just a problem with my setup (using aranym with a bridge to the host), since sometimes other network connections also fail. I've always used --disable-threaded-dns, since the only thread implementation currently available is pth, and that is non-preemptive and just causes problems because of this.

>Adding /usr/local/include is required in some BSD systems

I have disabled that currently when using gcc, since gcc should always look in that directories by default. Should that cause problems on BSD system, the test could also be changed to ``if test "$cross_compiling" = no``

Other things that i changed: looking for png library uses png-config. I've tested it also on linux, but may need some testing for other systems.

For FLTK i currently just use -lfltk when cross-compiling, since it does not seem to require any special cflags. Maybe that test could also be changed to some ``AC_CHECK_LIB``. 

The dpi programs have to be linked explicitly to the x11 libraries. This is again only needed because of static libraries, but should not hurt on other systems.

Searching for openssl also uses pkg-config now. I have no mbedtls yet, so i don't know what files are installed there.

All in all the patches aren't that large, so if you don't want to apply them, i can just keep them as mint-specific patches.

But note that this is all quite experimental. There are other quirks currently, some drawing problems (which i suspect to be fVDI problems in combination with aranym), the tooltips sometimes immediately disappearing again etc. And of course that X.App that is needed is also quite experimental.

However the rendering always is quite strange, also in the linux version of dillo. Maybe some features of CSS that are not implemented yet?

[dillo.patch.txt](https://github.com/dillo-browser/dillo/files/13761123/dillo.patch.txt)


--%--
From: rodarima
Date: Sun, 24 Dec 2023 14:20:57 +0000

I would like to continue the discussion for Atari support here https://github.com/dillo-browser/dillo/issues/34, as I want this PR to be focused on the support for OpenSSL 1.1 only. The other issues we can deal in other PR, so we break them into small changes.