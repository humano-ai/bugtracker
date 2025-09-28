Title: a_Tls_openssl_connect: Assertion `!ERR_get_error()' failed.
Author: badsectoracula
Created: Wed, 03 Jan 2024 03:09:50 +0000
State: closed

Trying to open a site with https causes an assertion error to kill Dillo. 

Console output from after trying to visit `lite.duckduckgo.com`:

```Nav_open_url: new url='http://lite.duckduckgo.com'
Dns_server [0]: lite.duckduckgo.com is 40.114.177.156
Connecting to 40.114.177.156:80
Nav_open_url: new url='https://lite.duckduckgo.com/'
Connecting to 40.114.177.156:443
lite.duckduckgo.com: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /C=US/ST=Pennsylvania/L=Paoli/O=Duck Duck Go, Inc./CN=*.duckduckgo.com
sha256 2048-bit RSA: /C=US/O=DigiCert Inc/CN=DigiCert Global G2 TLS RSA SHA256 2020 CA1
root: /C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert Global Root G2
Nav_open_url: new url='https://lite.duckduckgo.com/lite/'
Connecting to 40.114.177.156:443
dillo: tls_openssl.c:1183: a_Tls_openssl_connect: Assertion `!ERR_get_error()' failed.
Aborted (core dumped)
```

Notice the **tls_openssl.c:1183** part. The [relevant line](https://github.com/dillo-browser/dillo/blob/95627efadf55c39901928ee730d22de55cdcc209/src/IO/tls_openssl.c#L1183).

I'm using **OpenSSL 3.1.4** from **openSUSE**.  This does not happen with mbedSSL though i don't think the SSL library is the issue, the linked code seems to assume there are no OpenSSL errors before entering this function, but somewhere an error is added to OpenSSL's error queue that isn't checked.

--%--
From: crisdosaygo
Date: Wed, 03 Jan 2024 03:20:10 +0000

Could be related to [this](https://news.ycombinator.com/item?id=38849994). The author talks about some possible causes and workarounds in that comment! @badsectoracula cool profile image -- classic Netscape animation! 😸 

--%--
From: badsectoracula
Date: Wed, 03 Jan 2024 03:25:39 +0000

I wrote toplevel comment and made this bug report as rodarima asked :-).

I placed a breakpoint in OpenSSL's `ERR_put_error` function (openSUSE has debug symbol download configured for gdb) to see where that error comes from. It seems to be [this line](https://github.com/dillo-browser/dillo/blob/95627efadf55c39901928ee730d22de55cdcc209/src/IO/tls_openssl.c#L1049). Judging from the comment it used to have issues with old versions of OpenSLL? Perhaps new versions also have the same issue? Sadly there is no debug info for libssl nor i could see what error exactly was added.

--%--
From: crisdosaygo
Date: Wed, 03 Jan 2024 04:33:35 +0000

@badsectoracula seems a bit of discussion on this here: https://github.com/nodejs/node-v0.x-archive/issues/1719 

Error queue is not drained and that thread seems to suggest draining it. 😹 

As it's error queue it might be hard to locate the origin of anything in it. In the same file they drain it [here](https://github.com/dillo-browser/dillo/blob/95627efadf55c39901928ee730d22de55cdcc209/src/IO/tls_openssl.c#L239C1-L242C2)



--%--
From: rodarima
Date: Wed, 03 Jan 2024 11:43:00 +0000

Thanks for reporting it @badsectoracula

> Perhaps new versions also have the same issue?

I cannot reproduce it with OpenSSL 3.2.0 or 1.1.1.w (the ones I have available in Arch Linux):

```
% dillo 'https://lite.duckduckgo.com/'
Domain: Default accept.
dillo_dns_init: Here we go! (threaded)
Disabling cookies.
Nav_open_url: new url='https://lite.duckduckgo.com/'
Dns_server [0]: lite.duckduckgo.com is 52.142.124.215
Connecting to 52.142.124.215:443
lite.duckduckgo.com: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /C=US/ST=Pennsylvania/L=Paoli/O=Duck Duck Go, Inc./CN=*.duckduckgo.com
sha256 2048-bit RSA: /C=US/O=DigiCert Inc/CN=DigiCert Global G2 TLS RSA SHA256 2020 CA1
root: /C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert Global Root G2
peer name *.duckduckgo.com
Nav_open_url: new url='https://lite.duckduckgo.com/lite/'
Connecting to 52.142.124.215:443
peer name *.duckduckgo.com
Layout::resizeIdle calls = 1
```

Also, here my connection is not very fast so I might not be fast enough for the redirect to cause the error. I will try to link with the same version of OpenSSL in case is an issue of that specific version.

--%--
From: rodarima
Date: Mon, 08 Jan 2024 23:30:21 +0000

Cannot reproduce with OpenSSL 3.1.4 either and setting the duckduckgo host to the same IP (via /etc/hosts):
```
% LD_LIBRARY_PATH=/home/ram/dev/dillo/misc/openssl-3.1.4/install/lib64 src/dillo lite.duckduckgo.com
Domain: Default accept.
dillo_dns_init: Here we go! (threaded)
Disabling cookies.
Nav_open_url: new url='http://lite.duckduckgo.com'
Dns_server [0]: lite.duckduckgo.com is 40.114.177.156
Connecting to 40.114.177.156:80
Nav_open_url: new url='https://lite.duckduckgo.com/'
Connecting to 40.114.177.156:443
lite.duckduckgo.com: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /C=US/ST=Pennsylvania/L=Paoli/O=Duck Duck Go, Inc./CN=*.duckduckgo.com
sha256 2048-bit RSA: /C=US/O=DigiCert Inc/CN=DigiCert Global G2 TLS RSA SHA256 2020 CA1
root: /C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert Global Root G2
Nav_open_url: new url='https://lite.duckduckgo.com/lite/'
Connecting to 40.114.177.156:443
Layout::resizeIdle calls = 1
Dillo: normal exit!
```

This could still be explained by a race between closing the connection and the new one being opened, which in my setup occurs later.

I checked the code and it looks that the shutdown [is not very well done](https://www.openssl.org/docs/man3.2/man3/SSL_shutdown.html), we need to do some checking before ensuring the connection is closed (at least it is recommended) and ensure there are no errors in the queue. Here is how curl closes it: https://github.com/curl/curl/blob/912d80c68019d3d9a4ceb9993a596dff8009f4d0/lib/vtls/openssl.c#L1880

--%--
From: rodarima
Date: Wed, 10 Jan 2024 18:04:43 +0000

Managed to reproduce a similar error after shaping the bandwidth to 10KB/s and loading a big page via TLS (it takes a bit of time):

```
% trickle -s -d 10k -u 10k gdb --args build/src/dillo https://www.w3.org/TR/2011/WD-html5-20110405/Overview.html
...
Layout::resizeIdle calls = 104
Layout::resizeIdle calls = 105
Layout::resizeIdle calls = 106
TLS ALERT on write: decode error
dillo: ../../../src/IO/tls_openssl.c:1183: a_Tls_openssl_connect: Assertion `!ERR_get_error()' failed.
```

Although this is failing due to an ALERT, the same assert is triggering.

--%--
From: rodarima
Date: Wed, 10 Jan 2024 21:52:10 +0000

Similar symptoms as https://groups.google.com/g/dillo/c/zMRHPF1Aa7o/

--%--
From: rodarima
Date: Wed, 10 Jan 2024 22:16:23 +0000

> I placed a breakpoint in OpenSSL's ERR_put_error function

Hmm, I don't think this is possible in OpenSSL 3.1.4, the ERR_put_error function has been deprecated, and it is [only defined now with a macro](https://github.com/openssl/openssl/blob/openssl-3.1.4/include/openssl/err.h.in#L396-L402).

I suspect that you have another OpenSSL library installed, which is the one that Dillo is using and that still provides ERR_put_error() in which you have placed your breakpoint.

You can see which OpenSSL library is loaded by using:
```
$ ldd /usr/bin/dillo
```

Based on openSUSE website, they include the 1.1.1w version in the [openssl-1_1 package](https://software.opensuse.org/package/openssl-1_1).

I will try to reproduce it with 1.1.1w again, following this hypothesis.

Created issue #57 to prevent this situation in the future.

--%--
From: rodarima
Date: Thu, 11 Jan 2024 00:45:10 +0000

At least one of the problems is that SSL_shutdown() is trying to perform a write in the fd=7 to send a close notification, but the file descriptor was closed. This causes SSL_shutdown to return -1 (failure) and errno=6 (Bad file descriptor):

```
% gdb --args src/dillo duckduckgo.com
[...]
Using host libthread_db library "/usr/lib/libthread_db.so.1".
paths: Cannot open file '/home/ram/.dillo/dillorc': No such file or directory
paths: Using /home/ram/dev/dillo/git/install/etc/dillo/dillorc
Domain: Default accept.
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.2.0 23 Nov 2023
Disabling cookies.
** WARNING **: preferred cursive font "URW Chancery L" not found.
Nav_open_url: new url='http://duckduckgo.com'
[New Thread 0x7ffff619f6c0 (LWP 134332)]
Dns_server [0]: duckduckgo.com is 52.142.124.215
Connecting to 52.142.124.215:80
[Thread 0x7ffff619f6c0 (LWP 134332) exited]
Nav_open_url: new url='https://duckduckgo.com/'
Connecting to 52.142.124.215:443

Thread 1 "dillo" hit Breakpoint 1, a_Tls_openssl_connect (fd=7, url=0x5555559ddb60) at IO/../../../src/IO/tls_openssl.c:1249
1249	   bool_t success = TRUE;
(gdb) b close
Breakpoint 2 at 0x7ffff6f1ca80 (25 locations)
(gdb) c
Continuing.
duckduckgo.com: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /C=US/ST=Pennsylvania/L=Paoli/O=Duck Duck Go, Inc./CN=*.duckduckgo.com
sha256 2048-bit RSA: /C=US/O=DigiCert Inc/CN=DigiCert Global G2 TLS RSA SHA256 2020 CA1
root: /C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert Global Root G2
NumPendingStyleSheets=1
NumPendingStyleSheets=2

Thread 1 "dillo" hit Breakpoint 2.1, 0x00007ffff6f1ca80 in close () from /usr/lib/libc.so.6
(gdb) bt
#0  0x00007ffff6f1ca80 in close () from /usr/lib/libc.so.6
#1  0x00005555556100e3 in dClose (fd=7) at ../../dlib/dlib.c:954 <----------------- Notice closing fd 7 
#2  0x00005555555de2b0 in Http_socket_reuse (SKey=2) at IO/../../../src/IO/http.c:870
#3  0x00005555555debb1 in a_Http_ccc (Op=2, Branch=2, Dir=2, Info=0x5555559dd920, Data1=0x0, Data2=0x55555566d0c1) at IO/../../../src/IO/http.c:1012
#4  0x000055555560148c in a_Chain_bcb (Op=2, Info=0x5555559dd8d0, Data1=0x0, Data2=0x55555566d0c1) at ../../src/chain.c:137
#5  0x0000555555609391 in a_Capi_ccc (Op=2, Branch=2, Dir=1, Info=0x5555559dd8d0, Data1=0x5555559eac70, Data2=0x555555662a18) at ../../src/capi.c:778
#6  0x00005555556013de in a_Chain_fcb (Op=2, Info=0x5555559dd920, Data1=0x5555559eac70, Data2=0x555555662a18) at ../../src/chain.c:114
#7  0x00005555555de8a1 in a_Http_ccc (Op=2, Branch=2, Dir=1, Info=0x5555559dd920, Data1=0x5555559eac70, Data2=0x0) at IO/../../../src/IO/http.c:964
#8  0x00005555556013de in a_Chain_fcb (Op=2, Info=0x5555559dd970, Data1=0x5555559eac70, Data2=0x0) at ../../src/chain.c:114
#9  0x00005555555e4e7b in a_IO_ccc (Op=2, Branch=2, Dir=1, Info=0x5555559dd970, Data1=0x555555a02eb0, Data2=0x0) at IO/../../../src/IO/IO.c:454
#10 0x00005555555e4465 in IO_read (io=0x555555a02eb0) at IO/../../../src/IO/IO.c:200
#11 0x00005555555e46ab in IO_callback (io=0x555555a02eb0) at IO/../../../src/IO/IO.c:273
#12 0x00005555555e4759 in IO_fd_read_cb (fd=7, data=0x3) at IO/../../../src/IO/IO.c:294
#13 0x00007ffff7e15c2d in fl_wait(double) () from /usr/lib/libfltk.so.1.3
#14 0x00007ffff7db8070 in Fl::wait(double) () from /usr/lib/libfltk.so.1.3
#15 0x00007ffff7db812a in Fl::run() () from /usr/lib/libfltk.so.1.3
#16 0x00005555555a9c4f in main (argc=2, argv=0x7fffffffdd38) at ../../src/dillo.cc:578
(gdb) b SSL_shutdown
Breakpoint 3 at 0x7ffff7358f60
(gdb) c
Continuing.

Thread 1 "dillo" hit Breakpoint 3, 0x00007ffff7358f60 in SSL_shutdown () from /usr/lib/libssl.so.3
(gdb) up
#1  0x00005555555e167a in Tls_close_by_key (connkey=1) at IO/../../../src/IO/tls_openssl.c:1102
1102	      int ret = SSL_shutdown(c->ssl);
(gdb) p c->fd
$1 = 7 <------------------------- But later trying to perform a shutdown on it
(gdb) bt
#0  0x00007ffff7358f60 in SSL_shutdown () from /usr/lib/libssl.so.3
#1  0x00005555555e167a in Tls_close_by_key (connkey=1) at IO/../../../src/IO/tls_openssl.c:1102
#2  0x00005555555e2098 in a_Tls_openssl_close_by_fd (fd=7) at IO/../../../src/IO/tls_openssl.c:1328
#3  0x00005555555df11f in a_Tls_close_by_fd (fd=7) at IO/../../../src/IO/tls.c:143
#4  0x00005555555dc8a7 in Http_socket_free (SKey=2) at IO/../../../src/IO/http.c:318
#5  0x00005555555de2ba in Http_socket_reuse (SKey=2) at IO/../../../src/IO/http.c:871
#6  0x00005555555debb1 in a_Http_ccc (Op=2, Branch=2, Dir=2, Info=0x5555559dd920, Data1=0x0, Data2=0x55555566d0c1) at IO/../../../src/IO/http.c:1012
#7  0x000055555560148c in a_Chain_bcb (Op=2, Info=0x5555559dd8d0, Data1=0x0, Data2=0x55555566d0c1) at ../../src/chain.c:137
#8  0x0000555555609391 in a_Capi_ccc (Op=2, Branch=2, Dir=1, Info=0x5555559dd8d0, Data1=0x5555559eac70, Data2=0x555555662a18) at ../../src/capi.c:778
#9  0x00005555556013de in a_Chain_fcb (Op=2, Info=0x5555559dd920, Data1=0x5555559eac70, Data2=0x555555662a18) at ../../src/chain.c:114
#10 0x00005555555de8a1 in a_Http_ccc (Op=2, Branch=2, Dir=1, Info=0x5555559dd920, Data1=0x5555559eac70, Data2=0x0) at IO/../../../src/IO/http.c:964
#11 0x00005555556013de in a_Chain_fcb (Op=2, Info=0x5555559dd970, Data1=0x5555559eac70, Data2=0x0) at ../../src/chain.c:114
#12 0x00005555555e4e7b in a_IO_ccc (Op=2, Branch=2, Dir=1, Info=0x5555559dd970, Data1=0x555555a02eb0, Data2=0x0) at IO/../../../src/IO/IO.c:454
#13 0x00005555555e4465 in IO_read (io=0x555555a02eb0) at IO/../../../src/IO/IO.c:200
#14 0x00005555555e46ab in IO_callback (io=0x555555a02eb0) at IO/../../../src/IO/IO.c:273
#15 0x00005555555e4759 in IO_fd_read_cb (fd=7, data=0x3) at IO/../../../src/IO/IO.c:294
#16 0x00007ffff7e15c2d in fl_wait(double) () from /usr/lib/libfltk.so.1.3
#17 0x00007ffff7db8070 in Fl::wait(double) () from /usr/lib/libfltk.so.1.3
#18 0x00007ffff7db812a in Fl::run() () from /usr/lib/libfltk.so.1.3
#19 0x00005555555a9c4f in main (argc=2, argv=0x7fffffffdd38) at ../../src/dillo.cc:578
```

--%--
From: badsectoracula
Date: Thu, 11 Jan 2024 04:20:13 +0000

> > I placed a breakpoint in OpenSSL's ERR_put_error function
> 
> Hmm, I don't think this is possible in OpenSSL 3.1.4, the ERR_put_error function has been deprecated, and it is [only defined now with a macro](https://github.com/openssl/openssl/blob/openssl-3.1.4/include/openssl/err.h.in#L396-L402).
> 
> I suspect that you have another OpenSSL library installed, which is the one that Dillo is using and that still provides ERR_put_error() in which you have placed your breakpoint.

You are right, i saw i had OpenSSL installed and assumed Dillo would use "the" OpenSSL.

Turns out i was wrong, Dillo is linked against _LibreSSL_, not OpenSSL. Specifically it is linked against **LibreSSL 3.7.0**. It links against the `libssl.so.53` and `libcrypto.so.50` shared objects which are provided by the `libssl53` and `libcrypto50` packages respectively, both of which mention they come from LibreSSL 3.7.0 in their descriptions and versions.

So perhaps the issue happens only with LibreSSL?


--%--
From: rodarima
Date: Thu, 11 Jan 2024 12:11:59 +0000

> You are right, i saw i had OpenSSL installed and assumed Dillo would use "the" OpenSSL.
> 
> Turns out i was wrong, Dillo is linked against _LibreSSL_, not OpenSSL. Specifically it is linked against **LibreSSL 3.7.0**. It links against the `libssl.so.53` and `libcrypto.so.50` shared objects which are provided by the `libssl53` and `libcrypto50` packages respectively, both of which mention they come from LibreSSL 3.7.0 in their descriptions and versions.
> 
> So perhaps the issue happens only with LibreSSL?

It looks like. I can reproduce it with LibreSSL (now it shows which library is in use):

```
% src/dillo lite.duckduckgo.com
[...]
TLS library: LibreSSL 3.8.2 <------- here
Disabling cookies.
** WARNING **: preferred cursive font "URW Chancery L" not found.
Nav_open_url: new url='http://lite.duckduckgo.com'
[New Thread 0x7ffff653b6c0 (LWP 145386)]
Dns_server [0]: lite.duckduckgo.com is 40.114.177.156
Connecting to 40.114.177.156:80
[Thread 0x7ffff653b6c0 (LWP 145386) exited]
Nav_open_url: new url='https://lite.duckduckgo.com/'
Connecting to 40.114.177.156:443
lite.duckduckgo.com: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /C=US/ST=Pennsylvania/L=Paoli/O=Duck Duck Go, Inc./CN=*.duckduckgo.com
sha256 2048-bit RSA: /C=US/O=DigiCert Inc/CN=DigiCert Global G2 TLS RSA SHA256 2020 CA1
root: /C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert Global Root G2
Nav_open_url: new url='https://lite.duckduckgo.com/lite/'
Connecting to 40.114.177.156:443
dillo: ../../../src/IO/tls_openssl.c:1187: a_Tls_openssl_connect: Assertion `!ERR_get_error()' failed.

```

 It seems to be caused by the attempt to shutdown the session with the file descriptor closed. In OpenSSL doesn't cause an error to be added to the queue (it just returns -1) but in LibreSSL it does. I'll test a bit more my fix and prepare a PR shortly.

Also, I never tried LibreSSL, didn't expected it to just link and run. I'll also consider adding it to the supported libraries.