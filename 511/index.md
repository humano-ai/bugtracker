Title: a_Tls_openssl_connect: Broken pipe
Author: Rodrigo Arias Mallo
Created: Tue, 11 Nov 2025 20:15:51 +0100
State: closed

```
hop% gdb --args dillo https://9front.org/
GNU gdb (GDB) 16.3
Copyright (C) 2024 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-pc-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from dillo...
(gdb) r
Starting program: /usr/local/bin/dillo https://9front.org/

This GDB supports auto-downloading debuginfo from the following URLs:
  <https://debuginfod.archlinux.org>
Enable debuginfod for this session? (y or [n])
Debuginfod has been disabled.
To make this setting permanent, add 'set debuginfod enabled off' to .gdbinit.
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib/libthread_db.so.1".
Keys::parseKey: Invalid command name: 'rel-next'
Keys::parseKey: Invalid command name: 'rel-prev'
Keys::parseKey: Invalid command name: 'rel-up'
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.6.0 1 Oct 2025
Enabling cookies as from cookiesrc...
Nav_open_url: new url='https://9front.org/'
[New Thread 0x7ffff61976c0 (LWP 1292605)]
Dns_server [0]: 9front.org is 168.235.82.245
Connecting to 168.235.82.245:443
[Thread 0x7ffff61976c0 (LWP 1292605) exited]
9front.org: TLSv1.2, cipher ECDHE-RSA-CHACHA20-POLY1305
sha256 2048-bit RSA: /CN=lists.9front.org
sha256 2048-bit RSA: /C=US/O=Let's Encrypt/CN=R12
root: /C=US/O=Internet Security Research Group/CN=ISRG Root X1
NumPendingStyleSheets=1
NumPendingStyleSheets=2
capi: Blocked mixed content: https://9front.org/ -> http://9front.org/img/release.front.png
capi: Blocked mixed content: https://9front.org/ -> http://9front.org/img/power36.gif
capi: Blocked mixed content: https://9front.org/ -> http://9front.org/img/mothracompat.gif
capi: Blocked mixed content: https://9front.org/ -> http://plan9.stanleylieber.com/werc/werc-propaganda/jpg/icon03.jpg
capi: Blocked mixed content: https://9front.org/ -> http://9front.org/img/nonazis.png
>>>> a_Nav_repush <<<<
Nav_open_url: new url='https://9front.org/'

Thread 1 "dillo" received signal SIGPIPE, Broken pipe.
0x00007ffff6e9f042 in ?? () from /usr/lib/libc.so.6
(gdb) bt
#0  0x00007ffff6e9f042 in ?? () from /usr/lib/libc.so.6
#1  0x00007ffff6e931ac in ?? () from /usr/lib/libc.so.6
#2  0x00007ffff6e931f4 in ?? () from /usr/lib/libc.so.6
#3  0x00007ffff6f0e53e in write () from /usr/lib/libc.so.6
#4  0x00007ffff7888ee9 in ?? () from /usr/lib/libcrypto.so.3
#5  0x00007ffff7878123 in ?? () from /usr/lib/libcrypto.so.3
#6  0x00007ffff787b97a in ?? () from /usr/lib/libcrypto.so.3
#7  0x00007ffff787babb in BIO_write () from /usr/lib/libcrypto.so.3
#8  0x00007ffff7f0a930 in ?? () from /usr/lib/libssl.so.3
#9  0x00007ffff7ea55c0 in ?? () from /usr/lib/libssl.so.3
#10 0x00007ffff7ea53f5 in ?? () from /usr/lib/libssl.so.3
#11 0x00005555555b4afa in Tls_close_by_key (connkey=3) at ../../../src/IO/tls_openssl.c:1085
#12 0x00005555555b631b in a_Tls_openssl_close_by_fd (fd=<optimized out>) at ../../../src/IO/tls_openssl.c:1363
#13 0x00005555555b3fe5 in a_Tls_close_by_fd (fd=<optimized out>) at ../../../src/IO/tls.c:162
#14 0x00005555555b31b6 in Http_socket_free (SKey=8) at ../../../src/IO/http.c:318
#15 0x00005555555b3868 in a_Http_ccc (Op=5, Branch=1, Dir=2, Info=0x555555a23680, Data1=0x0, Data2=0x0) at ../../../src/IO/http.c:1030
#16 0x00005555555778a8 in a_Chain_bcb (Op=Op@entry=5, Info=Info@entry=0x555555a19820, Data1=Data1@entry=0x0, Data2=Data2@entry=0x0) at ../../src/chain.c:139
#17 0x000055555557f28b in a_Capi_ccc (Op=5, Branch=<optimized out>, Dir=<optimized out>, Info=<optimized out>, Data1=<optimized out>, Data2=<optimized out>) at ../../src/capi.c:680
#18 0x000055555557f6c3 in a_Capi_conn_abort_by_url (url=0x555555a259c0) at ../../src/capi.c:209
#19 0x0000555555580298 in a_Capi_stop_client (Key=8, force=0) at ../../src/capi.c:632
#20 0x000055555556f4f2 in a_Bw_stop_clients (bw=bw@entry=0x555555805e20, flags=flags@entry=3) at ../../src/bw.c:197
#21 0x00005555555792ea in Nav_open_url (bw=bw@entry=0x555555805e20, url=url@entry=0x5555559e9130, requester=requester@entry=0x0, offset=offset@entry=0) at ../../src/nav.c:229
#22 0x0000555555579476 in Nav_repush (bw=0x555555805e20) at ../../src/nav.c:374
#23 Nav_repush_callback (data=0x555555805e20) at ../../src/nav.c:382
#24 0x00007ffff769301c in Fl::wait(double) () from /usr/lib/libfltk.so.1.3
#25 0x00007ffff7693213 in Fl::wait() () from /usr/lib/libfltk.so.1.3
#26 0x0000555555566bf3 in main (argc=2, argv=0x7fffffffd828) at ../../src/dillo.cc:621
(gdb) handle SIGPIPE nostop
Signal        Stop	Print	Pass to program	Description
SIGPIPE       No	Yes	Yes		Broken pipe
(gdb) c
Continuing.
a_Nav_expect_done: repush!
capi: Blocked mixed content: https://9front.org/ -> http://9front.org/img/release.front.png
capi: Blocked mixed content: https://9front.org/ -> http://9front.org/img/power36.gif
capi: Blocked mixed content: https://9front.org/ -> http://9front.org/img/mothracompat.gif
capi: Blocked mixed content: https://9front.org/ -> http://plan9.stanleylieber.com/werc/werc-propaganda/jpg/icon03.jpg
capi: Blocked mixed content: https://9front.org/ -> http://9front.org/img/nonazis.png
a_Tls_openssl_connect: queued error: error:80000020:system library::Broken pipe

Thread 1 "dillo" received signal SIGABRT, Aborted.
0x00007ffff6e9894c in ?? () from /usr/lib/libc.so.6
```

--%--
From: Rodrigo Arias Mallo
Date: Fri, 14 Nov 2025 20:37:11 +0100

From the backtrace:

    #11 0x00005555555b4afa in Tls_close_by_key (connkey=3) at ../../../src/IO/tls_openssl.c:1085

The problem seems to be in the `SSL_shutdown`:

    if (c->do_shutdown && !SSL_in_init(c->ssl)) {
       /* openssl 1.0.2f does not like shutdown being called during
        * handshake, resulting in ssl_undefined_function in the error queue.
        */
       SSL_shutdown(c->ssl);
    } else {
       MSG("Tls_close_by_key: Avoiding SSL shutdown for: %s\n", URL_STR(c->url));
    }
    SSL_free(c->ssl);

It is causing a SIGPIPE which is being ignored, but it is left in the error
queue. Then in the next connection causes an abort.

From the documentation:

    RETURN VALUES
           For both SSL_shutdown() and SSL_shutdown_ex() the following return
           values can occur

           [...]

           <0  The shutdown was not successful.  Call SSL_get_error(3) with the
               return value ret to find out the reason.  It can occur if an action
               is needed to continue the operation for nonblocking BIOs.

We need to flush the error queue before continuing.

Fixed in https://git.dillo-browser.org/dillo/commit/?id=097ad90e5bc83d71e417e851109deb190164cdaa
