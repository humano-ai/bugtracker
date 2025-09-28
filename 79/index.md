Title: TLS ALERT on write: decode error 
Author: rodarima
Created: Sat, 10 Feb 2024 22:05:50 +0000
State: closed

Abort when loading https://gopher.floodgap.com/gopher/gw:

```
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.1.4 24 Oct 2023
Enabling cookies as from cookiesrc...
** WARNING **: preferred cursive font "URW Chancery L" not found.
Nav_open_url: new url='https://gopher.floodgap.com/gopher/gw'
[New Thread 0x7ffff61f66c0 (LWP 663334)]
Dns_server [0]: gopher.floodgap.com is 107.132.118.74
[Thread 0x7ffff61f66c0 (LWP 663334) exited]
Connecting to 107.132.118.74:443
gopher.floodgap.com: TLSv1.2, cipher ECDHE-RSA-AES128-GCM-SHA256
sha256 2048-bit RSA: /CN=gopher.floodgap.com
sha256 2048-bit RSA: /C=US/O=Let's Encrypt/CN=R3
sha256 4096-bit RSA: /C=US/O=Internet Security Research Group/CN=ISRG Root X1
root: /O=Digital Signature Trust Co./CN=DST Root CA X3
Layout::resizeIdle calls = 1
Layout::resizeIdle calls = 2
Layout::resizeIdle calls = 3
Layout::resizeIdle calls = 4
Layout::resizeIdle calls = 5
Layout::resizeIdle calls = 6
Layout::resizeIdle calls = 7
Layout::resizeIdle calls = 8
Layout::resizeIdle calls = 9
Layout::resizeIdle calls = 10
TLS ALERT on write: decode error
Layout::resizeIdle calls = 11
TLS ALERT on write: decode error
Layout::resizeIdle calls = 12
TLS ALERT on write: decode error
Layout::resizeIdle calls = 13
TLS ALERT on write: decode error
Layout::resizeIdle calls = 14
a_Tls_openssl_connect: queued error: error:0A000126:SSL routines::unexpected eof while reading
a_Tls_openssl_connect: queued error: error:0A000126:SSL routines::unexpected eof while reading
a_Tls_openssl_connect: queued error: error:0A000126:SSL routines::unexpected eof while reading
a_Tls_openssl_connect: queued error: error:0A000126:SSL routines::unexpected eof while reading

Thread 1 "dillo" received signal SIGABRT, Aborted.
0x00007ffff6eac83c in ?? () from /usr/lib/libc.so.6
(gdb) bt
#0  0x00007ffff6eac83c in ?? () from /usr/lib/libc.so.6
#1  0x00007ffff6e5c668 in raise () from /usr/lib/libc.so.6
#2  0x00007ffff6e444b8 in abort () from /usr/lib/libc.so.6
#3  0x00005555555e1c84 in a_Tls_openssl_connect (fd=10, url=0x555555ae5e10) at IO/../../../src/IO/tls_openssl.c:1212
#4  0x00005555555df180 in a_Tls_connect (fd=10, url=0x555555ae5e10) at IO/../../../src/IO/tls.c:130
#5  0x00005555555dd349 in Http_connect_tls (info=0x555555adc5c0) at IO/../../../src/IO/http.c:521
#6  0x00005555555dd51c in Http_connect_socket_cb (fd=10, data=0x5) at IO/../../../src/IO/http.c:555
#7  0x00007ffff7e0111d in fl_wait(double) () from /usr/lib/libfltk.so.1.3
#8  0x00007ffff7da36bb in Fl::wait(double) () from /usr/lib/libfltk.so.1.3
#9  0x00007ffff7da37da in Fl::run() () from /usr/lib/libfltk.so.1.3
#10 0x00005555555a9c4f in main (argc=2, argv=0x7fffffffd838) at ../../src/dillo.cc:578
```

--%--
From: rodarima
Date: Sat, 10 Feb 2024 23:17:51 +0000

Using mbedTLS 2 and 3 work fine. Dillo is fetching 4 more resources over the same TLS session:

```
% src/dillo https://gopher.floodgap.com/gopher/gw
dillo_dns_init: Here we go! (threaded)
TLS library: mbed TLS 3.4.1
Trusting 146 TLS certificates.
Enabling cookies as from cookiesrc...
** WARNING **: preferred cursive font "URW Chancery L" not found.
Nav_open_url: new url='https://gopher.floodgap.com/gopher/gw'
Dns_server [0]: gopher.floodgap.com is 107.132.118.74
Connecting to 107.132.118.74:443
TLS: Fetching https://gopher.floodgap.com/gopher/gw
gopher.floodgap.com TLSv1.2, cipher TLS-ECDHE-RSA-WITH-AES-128-GCM-SHA256
Layout::resizeIdle calls = 1
Layout::resizeIdle calls = 2
Layout::resizeIdle calls = 3
Layout::resizeIdle calls = 4
Layout::resizeIdle calls = 5
Layout::resizeIdle calls = 6
Layout::resizeIdle calls = 7
TLS: Fetching https://gopher.floodgap.com/gopher/icons/text.gif
TLS: Fetching https://gopher.floodgap.com/gopher/icons/search.gif
Layout::resizeIdle calls = 8
TLS: Fetching https://gopher.floodgap.com/gopher/icons/menu.gif
Layout::resizeIdle calls = 9
Layout::resizeIdle calls = 10
Layout::resizeIdle calls = 11
TLS: Fetching https://gopher.floodgap.com/gopher/icons/url.gif
Layout::resizeIdle calls = 12
Layout::resizeIdle calls = 13
Layout::resizeIdle calls = 14
Layout::resizeIdle calls = 15
```

--%--
From: rodarima
Date: Sat, 10 Feb 2024 23:33:37 +0000

LibreSSL 3.8.2 works fine too

--%--
From: rodarima
Date: Sun, 11 Feb 2024 10:38:14 +0000

In OpenSSL, SSL_in_init() is returning 1, so the branch that shutsdown the SSL connection is not taken, calling SSL_free() directly. On LibreSSL this doesn't happen, and the connection is shutdown first.

--%--
From: rodarima
Date: Mon, 12 Feb 2024 23:03:50 +0000

Rebuilding OpenSSL 3.2.1 with debug symbols produces this backtrace when the alert is issued:
```
(gdb) bt
#0  Tls_info_cb (ssl=0x555555907e00, where=16392, ret=562) at IO/../../../src/IO/tls_openssl.c:193
#1  0x00007ffff70f4f0a in ssl3_dispatch_alert (s=0x555555907e00) at ssl/s3_msg.c:155
#2  0x00007ffff70f4b66 in ssl3_send_alert (s=0x555555907e00, level=2, desc=50) at ssl/s3_msg.c:69
#3  0x00007ffff7191009 in ossl_statem_send_fatal (s=0x555555907e00, al=50) at ssl/statem/statem.c:152
#4  0x00007ffff71910db in ossl_statem_fatal (s=0x555555907e00, al=50, reason=294, fmt=0x0) at ssl/statem/statem.c:170
#5  0x00007ffff716ba70 in ossl_tls_handle_rlayer_return (s=0x555555907e00, writing=0, ret=-3, file=0x7ffff71ca130 "ssl/record/rec_layer_s3.c", line=645) at ssl/record/rec_layer_s3.c:475
#6  0x00007ffff716c047 in ssl3_read_bytes (ssl=0x555555907e00, type=23 '\027', recvd_type=0x0,
    buf=0x7fffffffb3d0 " \"/gopher/gw\">Floodgap home gopher</a> </td>\n<td align = \"center\" valign=\"middle\">version 632 port 2</td>\n<td align = \"right\" valign = \"middle\"><i>All access must be in\naccordance with <a href = \"http"..., len=8192, peek=0, readbytes=0x7fffffffb310) at ssl/record/rec_layer_s3.c:645
#7  0x00007ffff70f30c4 in ssl3_read_internal (s=0x555555907e00, buf=0x7fffffffb3d0, len=8192, peek=0, readbytes=0x7fffffffb310) at ssl/s3_lib.c:4528
#8  0x00007ffff70f3194 in ssl3_read (s=0x555555907e00, buf=0x7fffffffb3d0, len=8192, readbytes=0x7fffffffb310) at ssl/s3_lib.c:4551
#9  0x00007ffff71065c9 in ssl_read_internal (s=0x555555907e00, buf=0x7fffffffb3d0, num=8192, readbytes=0x7fffffffb310) at ssl/ssl_lib.c:2343
#10 0x00007ffff7106664 in SSL_read (s=0x555555907e00, buf=0x7fffffffb3d0, num=8192) at ssl/ssl_lib.c:2357
#11 0x00005555555e2208 in a_Tls_openssl_read (conn=0x555555903480, buf=0x7fffffffb3d0, len=8192) at IO/../../../src/IO/tls_openssl.c:1276
#12 0x00005555555df233 in a_Tls_read (conn=0x555555903480, buf=0x7fffffffb3d0, len=8192) at IO/../../../src/IO/tls.c:158
#13 0x00005555555e4588 in IO_read (io=0x555555901fa0) at IO/../../../src/IO/IO.c:172
#14 0x00005555555e4941 in IO_callback (io=0x555555901fa0) at IO/../../../src/IO/IO.c:273
#15 0x00005555555e49ef in IO_fd_read_cb (fd=6, data=0x1) at IO/../../../src/IO/IO.c:294
#16 0x00007ffff7e0111d in fl_wait(double) () from /usr/lib/libfltk.so.1.3
#17 0x00007ffff7da36bb in Fl::wait(double) () from /usr/lib/libfltk.so.1.3
#18 0x00007ffff7da37da in Fl::run() () from /usr/lib/libfltk.so.1.3
#19 0x00005555555a9c4f in main (argc=2, argv=0x7fffffffd828) at ../../src/dillo.cc:578
```

--%--
From: rodarima
Date: Tue, 13 Feb 2024 22:08:12 +0000

So, what seems to be hapenning is that the server is sending the page in small chunks but there is some delay in sending the last parts, and then OpenSSL cannot decode it:

![image](https://github.com/dillo-browser/dillo/assets/3866127/0bcb60d0-86e5-4c6f-8ec3-4083542d7f5b)

However, the parts being decoded are enough for Dillo to begin requesting other parts of the website, which spawn another three extra connections *before* the complete page is sent:

![image](https://github.com/dillo-browser/dillo/assets/3866127/57045bc0-1970-4fbe-8f9f-fb50299d1102)

Can this be a limit on the server of only 3 connections per client?

--%--
From: rodarima
Date: Tue, 13 Feb 2024 22:16:58 +0000

Setting `http_max_conn=1` in dillorc continues to cause the same problem, but this time there are no other request in flight:

![image](https://github.com/dillo-browser/dillo/assets/3866127/6a9f7ec0-4b66-44f1-aff8-04ec684621a1)


--%--
From: rodarima
Date: Tue, 13 Feb 2024 22:29:49 +0000

A similar problem is reproduced with cURL and OpenSSL:

```
% curl -sv https://gopher.floodgap.com/gopher/gw > /dev/null
*   Trying 107.132.118.74:443...
* Connected to gopher.floodgap.com (107.132.118.74) port 443
* ALPN: curl offers h2,http/1.1
} [5 bytes data]
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
} [512 bytes data]
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: none
{ [5 bytes data]
* TLSv1.3 (IN), TLS handshake, Server hello (2):
{ [57 bytes data]
* TLSv1.2 (IN), TLS handshake, Certificate (11):
{ [3972 bytes data]
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
{ [333 bytes data]
* TLSv1.2 (IN), TLS handshake, Server finished (14):
{ [4 bytes data]
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
} [70 bytes data]
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
} [1 bytes data]
* TLSv1.2 (OUT), TLS handshake, Finished (20):
} [16 bytes data]
* TLSv1.2 (IN), TLS handshake, Finished (20):
{ [16 bytes data]
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN: server did not agree on a protocol. Uses default.
* Server certificate:
*  subject: CN=gopher.floodgap.com
*  start date: Jan  1 12:33:16 2024 GMT
*  expire date: Mar 31 12:33:15 2024 GMT
*  subjectAltName: host "gopher.floodgap.com" matched cert's "gopher.floodgap.com"
*  issuer: C=US; O=Let's Encrypt; CN=R3
*  SSL certificate verify ok.
* using HTTP/1.x
} [5 bytes data]
> GET /gopher/gw HTTP/1.1
> Host: gopher.floodgap.com
> User-Agent: curl/8.4.0
> Accept: */*
>
{ [5 bytes data]
< HTTP/1.1 200 Floodgap Gopher Proxy Okay
< Server: gopher/gw
< Content-type: text/html
< Connection: close
<
{ [923 bytes data]
* OpenSSL SSL_read: SSL_ERROR_SYSCALL, errno 0
* Closing connection
} [5 bytes data]
* TLSv1.2 (OUT), TLS alert, close notify (256):
} [2 bytes data]
% echo $?
56
```

However, they only send a close notify alert and then close the connection:

![image](https://github.com/dillo-browser/dillo/assets/3866127/812ac339-4355-4bb2-a8f8-523d80f5b8e2)


--%--
From: rodarima
Date: Tue, 13 Feb 2024 22:33:21 +0000

With OpenSSL 3.1.4, cURL doesn't exit with an error:

```
% curl -vq https://gopher.floodgap.com/gopher/gw > /dev/null
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0*   Trying 107.132.118.74:443...
* Connected to gopher.floodgap.com (107.132.118.74) port 443
* ALPN: curl offers h2,http/1.1
} [5 bytes data]
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
} [512 bytes data]
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: none
{ [5 bytes data]
* TLSv1.3 (IN), TLS handshake, Server hello (2):
{ [57 bytes data]
* TLSv1.2 (IN), TLS handshake, Certificate (11):
{ [3972 bytes data]
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
{ [333 bytes data]
* TLSv1.2 (IN), TLS handshake, Server finished (14):
{ [4 bytes data]
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
} [70 bytes data]
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
} [1 bytes data]
* TLSv1.2 (OUT), TLS handshake, Finished (20):
} [16 bytes data]
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* TLSv1.2 (IN), TLS handshake, Finished (20):
{ [16 bytes data]
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN: server did not agree on a protocol. Uses default.
* Server certificate:
*  subject: CN=gopher.floodgap.com
*  start date: Jan  1 12:33:16 2024 GMT
*  expire date: Mar 31 12:33:15 2024 GMT
*  subjectAltName: host "gopher.floodgap.com" matched cert's "gopher.floodgap.com"
*  issuer: C=US; O=Let's Encrypt; CN=R3
*  SSL certificate verify ok.
* using HTTP/1.x
} [5 bytes data]
> GET /gopher/gw HTTP/1.1
> Host: gopher.floodgap.com
> User-Agent: curl/8.4.0
> Accept: */*
>
{ [5 bytes data]
< HTTP/1.1 200 Floodgap Gopher Proxy Okay
< Server: gopher/gw
< Content-type: text/html
< Connection: close
<
{ [923 bytes data]
100 19659    0 19659    0     0   8834      0 --:--:--  0:00:02 --:--:--  8835
* Closing connection
} [5 bytes data]
* TLSv1.2 (OUT), TLS alert, close notify (256):
} [2 bytes data]
% echo $?
0
```

--%--
From: rodarima
Date: Sat, 17 Feb 2024 09:41:01 +0000

Related:

> $ man SSL_get_error
> ...
> NOTES
> Some TLS implementations do not send a close_notify alert on shutdown.
> 
> On an unexpected EOF, versions before OpenSSL 3.0 returned SSL_ERROR_SYSCALL, nothing was added to the error stack, and errno was 0.  Since OpenSSL 3.0 the returned error is SSL_ERROR_SSL with a meaningful error on the error stack.
