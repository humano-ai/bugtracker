Title: Dillo 3.1.0: Freeze on Nav_open_url in Cygwin
Author: Isles487
Created: Sun, 19 May 2024 18:06:47 +0000
State: closed

In updated Cygwin, using 3.1.0 release of Dillo, I am encountering process freezes when attempting to open Urls:

Windows 11, 64 bit
Cygwin64 terminal
VcXsrv 1.20.14.0

Console:

$ DISPLAY=:0.0 dillo
paths: Cannot open file '/home/someuser/.dillo/dillorc': No such file or directory
paths: Using /usr/local/etc/dillo/dillorc
paths: Cannot open file '/home/someuser/.dillo/keysrc': No such file or directory
paths: Using /usr/local/etc/dillo/keysrc
paths: Cannot open file '/home/someuser/.dillo/domainrc': No such file or directory
paths: Using /usr/local/etc/dillo/domainrc
Domain: Default accept.
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.0.13 30 Jan 2024
Disabling cookies.
paths: Cannot open file '/home/someuser/.dillo/hsts_preload': No such file or directory
paths: Using /usr/local/etc/dillo/hsts_preload
Nav_open_url: new url='about:splash'
Nav_open_url: new url='https://dillo-browser.github.io/'
Dns_server [0]: dillo-browser.github.io is 185.199.108.153 185.199.110.153 185.199.109.153 185.199.111.153
Connecting to 185.199.108.153:443
dillo-browser.github.io: TLSv1.3, cipher TLS_AES_128_GCM_SHA256
sha256 2048-bit RSA: /C=US/ST=California/L=San Francisco/O=GitHub, Inc./CN=*.github.io
sha256 2048-bit RSA: /C=US/O=DigiCert Inc/CN=DigiCert Global G2 TLS RSA SHA256 2020 CA1
root: /C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert Global Root G2
Nav_open_url: new url='https://www.fltk.org/'

At this point the application becomes unresponsive and I need to kill via Task Manager.


--%--
From: rodarima
Date: Sun, 19 May 2024 18:19:35 +0000

Does it also happen with Xorg? https://github.com/dillo-browser/dillo/blob/master/doc/install.md#windows-via-cygwin

--%--
From: Isles487
Date: Sun, 19 May 2024 18:22:01 +0000

> Does it also happen with Xorg? https://github.com/dillo-browser/dillo/blob/master/doc/install.md#windows-via-cygwin

Yes it does, same issue after using startxwin and then connecting to the X server via a different cygwin terminal window.

--%--
From: rodarima
Date: Sun, 19 May 2024 19:06:04 +0000

> Yes it does, same issue after using startxwin and then connecting to the X server via a different cygwin terminal window.

I cannot reproduce it when using mbedTLS 2.23.0, I will try with OpenSSL too.

--%--
From: rodarima
Date: Sun, 19 May 2024 19:17:50 +0000

I can reproduce it with OpenSSL 3.0.13. I will take a look and see if I can find the problem, thanks for reporting.

In the meanwhile, you can install mbedTLS (mbedtls-devel) and configure Dillo with `--disable-openssl` so it uses it instead of OpenSSL, which seems to be working fine.

--%--
From: Isles487
Date: Sun, 19 May 2024 19:19:54 +0000

> I can reproduce it with OpenSSL 3.0.13. I will take a look and see if I can find the problem, thanks for reporting.
> 
> In the meanwhile, you can install mbedTLS (mbedtls-devel) and configure Dillo with `--disable-openssl` so it uses it instead of OpenSSL, which seems to be working fine.

Thank you for looking into this and confirming! 

--%--
From: rodarima
Date: Sun, 19 May 2024 19:40:47 +0000

There seems to be a problem which only occurs with OpenSSL and when the threaded DNS resolver is enabled.

When building with OpenSSL, you can disable the threaded DNS resolver by configuring Dillo with `--disable-threaded-dns`. That seems to be working fine too.

I cannot see where the problem is coming from, as the stack seems corrupted from GDB:
```
...
[New Thread 3376.0x3e0]
[New Thread 3376.0x1b60]
[New Thread 3376.0x223c]
[New Thread 3376.0x2b50]
Nav_open_url: new url='about:splash'
[New Thread 3376.0x2e58]
Nav_open_url: new url='https://dillo-browser.github.io/'
[New Thread 3376.0x5ec]
Dns_server [0]: dillo-browser.github.io is 185.199.109.153 185.199.110.153 185.199.108.153 185.199.111.153

Thread 11 "dillo" received signal SIGSEGV, Segmentation fault.
[Switching to Thread 3376.0x5ec]
0x0000000000000000 in ?? ()
(gdb) bt
#0  0x0000000000000000 in ?? ()
#1  0x00007ffdcc659a03 in cygwin1!.getreent () from /usr/bin/cygwin1.dll
#2  0x00007ffdcc73a3bb in timegm () from /usr/bin/cygwin1.dll
#3  0x000000007ffe0385 in ?? ()
Backtrace stopped: previous frame inner to this frame (corrupt stack?)
```

--%--
From: rodarima
Date: Sun, 19 May 2024 20:11:29 +0000

So, I took a look and what seems to be happening is that after a thread is spawned to resolve a host, the thread finishes and exits by returning NULL. The control is returned to cygwin, at which point the `rbp` (the base of the stack) is set to zero:

```
(gdb) p $rbp
$12 = (void *) 0x0
```

Causing a SEGFAULT in the next push instruction.

I'm not sure if this is a problem on Cygwin or on Dillo side. I cannot enable Asan on Cygwin, as it doesn't seem to be supported. With the stack protector enabled, there is no warning of any kind.

--%--
From: rodarima
Date: Sun, 19 May 2024 20:23:05 +0000

Here is the bug, the thread has overwritten the stored rbp register in the stack with 0, causing the `pop %rbp`  instruction to set the value of rbp to zero.

![image](https://github.com/dillo-browser/dillo/assets/3866127/03ceaa54-8465-4a17-9089-706ddbcdf5c1)

I just need to see what is causing it, probably an stack overflow.

--%--
From: rodarima
Date: Sun, 19 May 2024 20:56:42 +0000

Well, it seems the rbp register is not the problem, as it enters the Dns_server function with value zero. The problem seems to be the [detached state](https://github.com/dillo-browser/dillo/blob/ea2263231abc770d5d87fcdb95fddd80679c5906/src/dns.c#L356):

```
pthread_attr_setdetachstate(&thrATTR, PTHREAD_CREATE_DETACHED);
```

When that line is removed, the thread works fine. But when it is set, the alloca call done by cywgin after the thread finishes is failing. This starts to look like a bug in Cygwin.

As a workaround, disabling DNS threads seems to be the best solution for now.

--%--
From: Isles487
Date: Sun, 19 May 2024 20:58:58 +0000

> Well, it seems the rbp register is not the problem, as it enters the Dns_server function with value zero. The problem seems to be the [detached state](https://github.com/dillo-browser/dillo/blob/ea2263231abc770d5d87fcdb95fddd80679c5906/src/dns.c#L356):
> 
> ```
> pthread_attr_setdetachstate(&thrATTR, PTHREAD_CREATE_DETACHED);
> ```
> 
> When that line is removed, the thread works fine. But when it is set, the alloca call done by cywgin after the thread finishes is failing. This starts to look like a bug in Cygwin.
> 
> As a workaround, disabling DNS threads seems to be the best solution for now.

I don't know if this information is useful in determining whether Cygwin is the issue or not, but interestingly when I compile the links2 browser: http://links.twibright.com/, I need to run with -async-dns disabled otherwise the browser crashes after loading more than one page - also using same openssl.

--%--
From: rodarima
Date: Sun, 19 May 2024 21:15:00 +0000

Here is a reproducer which causes a SEGFAULT with OpenSSL only:

```
$ cat p.c
#include <pthread.h>
#include <unistd.h>
#include <stdio.h>

#include <openssl/ssl.h>

#define N 4

static void *foo(void *data)
{
        printf("hello th %d\n", (int) data);
        return NULL;
}

int main()
{
        SSL_library_init();
        pthread_t th[N];
        pthread_attr_t attr;
        pthread_attr_init(&attr);
        pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);

        for (int i = 0; i < N; i++)
                pthread_create(&th[i], &attr, foo, (void *) i);

        sleep(5);
}

$ gcc p.c -lssl -pthread -o p

$ gdb ./p
GNU gdb (GDB) (Cygwin 13.2-1) 13.2
Copyright (C) 2023 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-pc-cygwin".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./p...
(gdb) r
Starting program: /home/PC/dillo/build-openssl/p
[New Thread 7332.0x1f2c]
[New Thread 7332.0x99c]
[New Thread 7332.0x27d4]
[New Thread 7332.0x35e0]
[New Thread 7332.0x21dc]
[New Thread 7332.0x3170]
[New Thread 7332.0x1ea4]
[New Thread 7332.0x3180]
hello th 0
hello th 1
hello th 2
[Thread 7332.0x3170 exited with code 0]
hello th 3

Thread 6 "p" received signal SIGSEGV, Segmentation fault.
[Switching to Thread 7332.0x21dc]
0x0000000000000000 in ?? ()
```

This is likely a bug in Cygwin triggered by OpenSSL, so I will report it to them. In the meanwhile I will modify the documentation for Windows to disable the threaded DNS resolver,

--%--
From: rodarima
Date: Mon, 20 May 2024 18:32:47 +0000

Confirmed: https://cygwin.com/pipermail/cygwin/2024-May/255975.html

--%--
From: Isles487
Date: Mon, 20 May 2024 19:23:55 +0000

Thank you again for looking into this so quickly and keeping me updated on this! Appreciate your work. Let me know if appropriate to close now.

--%--
From: rodarima
Date: Mon, 20 May 2024 19:28:12 +0000

> Thank you again for looking into this so quickly and keeping me updated on this! Appreciate your work. Let me know if appropriate to close now.

Don't worry, it will be closed automatically when I merge https://github.com/dillo-browser/dillo/pull/173 :-)