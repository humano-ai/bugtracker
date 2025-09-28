Title: Dillo 3.2.0: view source consistently freezes
Author: mbuechse
Created: Mon, 11 Aug 2025 10:29:45 +0000
State: closed

On Alpine:

```shell
$ dillo file:/usr/share/doc/dillo/user_help.html
paths: Cannot open file '/home/mbue/.dillo/keysrc': No such file or directory
paths: Using /etc/dillo/keysrc
paths: Cannot open file '/home/mbue/.dillo/domainrc': No such file or directory
paths: Using /etc/dillo/domainrc
Domain: Default accept.
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.5.1 1 Jul 2025
Disabling cookies.
paths: Cannot open file '/home/mbue/.dillo/hsts_preload': No such file or directory
paths: Using /etc/dillo/hsts_preload
Nav_open_url: new url='file:/usr/share/doc/dillo/user_help.html'
Nav_open_url: new url='dpi:/vsource/:file:/usr/share/doc/dillo/user_help.html'
^C

$ ps -elf | grep vsource                        
 8695 mbue      0:06 /usr/lib/dillo/dpi/vsource/vsource.filter.dpi
 8727 mbue      0:00 grep vsource

$ kill 8695
```

The filter runs at a high CPU usage, causing my laptop's fan to spin up, but it doesn't produce anything.

--%--
From: rodarima
Date: Mon, 11 Aug 2025 11:34:02 +0000

Thanks for the report, but I cannot reproduce it here. Can you record a trace of the `vsource.filter.dpi` program with strace during the issue? Something like:

```
$ strace -o strace.log -s 500 -p $(pidof vsource.filter.dpi)
(wait a few seconds, then Ctrl+C to stop)
```

Then attach the strace.log file here.

--%--
From: mbuechse
Date: Mon, 11 Aug 2025 12:16:26 +0000

Thanks for the precise instructions! I'm afraid the file came out empty.
I could only start strace after I had opened the source view, because otherwise there was no process to attach to.
And then, apparently, nothing happened.
I will give it more time (longer than a few seconds).

--%--
From: mbuechse
Date: Mon, 11 Aug 2025 12:19:40 +0000

A quick check with `gdb`

```shell
# gdb -p $(pidof vsource.filter.dpi)
GNU gdb (GDB) 15.2
Copyright (C) 2024 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-alpine-linux-musl".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word".
Attaching to process 18067
Reading symbols from /usr/lib/dillo/dpi/vsource/vsource.filter.dpi...
(No debugging symbols found in /usr/lib/dillo/dpi/vsource/vsource.filter.dpi)
Reading symbols from /lib/ld-musl-x86_64.so.1...
Reading symbols from /usr/lib/debug//lib/ld-musl-x86_64.so.1.debug...
printf_core (f=f@entry=0x7ffd23d137e0, 
    fmt=fmt@entry=0x55ad401ec073 "\n<html><head>\n<title>Source for %s</title>\n<style type=\"text/css\">\n  body {\n    white-space: pre-wrap;\n    font-family: monospace;\n    margin: 0;\n    width: 100%;\n  }\n  table { border:0 }\n  td.num {\n "..., ap=ap@entry=0x7ffd23d13648, 
    nl_arg=nl_arg@entry=0x7ffd23d136e0, nl_type=nl_type@entry=0x7ffd23d13660)
    at src/stdio/vfprintf.c:457

warning: 457	src/stdio/vfprintf.c: No such file or directory
```

--%--
From: rodarima
Date: Mon, 11 Aug 2025 12:20:58 +0000

Thanks!, can you share the backtrace with `bt`?

--%--
From: mbuechse
Date: Mon, 11 Aug 2025 12:26:29 +0000

Sure. It doesn't tell much, I'm afraid.

```text
(gdb) bt
#0  printf_core (f=f@entry=0x7ffd23d137e0, 
    fmt=fmt@entry=0x55ad401ec073 "\n<html><head>\n<title>Source for %s</title>\n<style type=\"text/css\">\n  body {\n    white-space: pre-wrap;\n    font-family: monospace;\n    margin: 0;\n    width: 100%;\n  }\n  table { border:0 }\n  td.num {\n "..., ap=ap@entry=0x7ffd23d13648, 
    nl_arg=nl_arg@entry=0x7ffd23d136e0, nl_type=nl_type@entry=0x7ffd23d13660)
    at src/stdio/vfprintf.c:457
#1  0x00007f5de41c9100 in vfprintf (f=f@entry=0x7ffd23d137e0, 
    fmt=0x55ad401ec073 "\n<html><head>\n<title>Source for %s</title>\n<style type=\"text/css\">\n  body {\n    white-space: pre-wrap;\n    font-family: monospace;\n    margin: 0;\n    width: 100%;\n  }\n  table { border:0 }\n  td.num {\n "..., ap=<optimized out>) at src/stdio/vfprintf.c:690
#2  0x00007f5de41c95af in vsnprintf (s=<optimized out>, n=<optimized out>, 
    fmt=<optimized out>, ap=<optimized out>) at src/stdio/vsnprintf.c:49
#3  0x000055ad401eae98 in ?? ()
#4  0x000055ad401eafb5 in ?? ()
#5  0x000055ad401e9673 in ?? ()
#6  0x000055ad401e91ac in ?? ()
#7  0x00007f5de41a7496 in libc_start_main_stage2 (main=0x55ad401e9030, 
    argc=1, argv=0x7ffd23d13b78) at src/env/__libc_start_main.c:95
#8  0x000055ad401e925d in ?? ()
#9  0x0000000000000001 in ?? ()
#10 0x00007ffd23d14beb in ?? ()
#11 0x0000000000000000 in ?? ()
```

--%--
From: rodarima
Date: Mon, 11 Aug 2025 12:31:32 +0000

Based on the fact that you are not walking through any syscall, it looks that you may be looping here:

https://github.com/dillo-browser/dillo/blob/v3.2.0/dlib/dlib.c#L407-L432

There may be a corner case for that particular size of the buffer that is causing it to never be able to find a suitable size for that string.

Are you able to view the source code of other pages which have a different title? For example `about:splash`?

--%--
From: mbuechse
Date: Mon, 11 Aug 2025 12:40:54 +0000

No, other pages don't work either. Maybe it's connected to musl?
https://git.musl-libc.org/cgit/musl/tree/src/stdio/vsnprintf.c?h=v1.2.5

--%--
From: rodarima
Date: Mon, 11 Aug 2025 13:16:25 +0000

Maybe. We can confirm that it is the case by adding these debug statements:

```diff
diff --git a/dlib/dlib.c b/dlib/dlib.c
index 2cbd083e..801d8abc 100644
--- a/dlib/dlib.c
+++ b/dlib/dlib.c
@@ -402,6 +402,8 @@ void dStr_vsprintfa (Dstr *ds, const char *format, va_list argp)
 {
    int n, n_sz;

+   fprintf(stderr, "dStr_vprintfa: enter ds->len=%d, ds->sz=%d\n", ds->len, ds->sz);
+
    if (ds && format) {
       va_list argp2;         /* Needed in case of looping on non-32bit arch */
       while (1) {
@@ -428,9 +430,13 @@ void dStr_vsprintfa (Dstr *ds, const char *format, va_list argp)
             n_sz = ds->sz * 2;
          }
 #endif
+         fprintf(stderr, "dStr_vprintfa: resizing, n=%d, n_sz=%d, keep=%d\n",
+               n, n_sz, (ds->len > 0) ? 1 : 0);
          dStr_resize(ds, n_sz, (ds->len > 0) ? 1 : 0);
       }
    }
+
+   fprintf(stderr, "dStr_vprintfa: exit ds->len=%d, ds->sz=%d\n", ds->len, ds->sz);
 }

 /**
```

[debug-dlib.patch.txt](https://github.com/user-attachments/files/21715372/debug-dlib.patch.txt)

You will need *first remove the current dillo 3.2.0* and then build it from source. I suggest trying with the tip of master, as it should be reproducible there:


```
git clone https://github.com/dillo-browser/dillo.git
cd dillo
git apply < debug-dlib.patch.txt
./autogen.sh
mkdir build
cd build
../configure CFLAGS='-Og -g' CXXFLAGS='-Og -g'
make
doas make install # must be installed!
dpidc stop
```

Then try again, if it fails, it will start looping on the "dStr_vprintfa: resizing" line. We will see also which size parameter is causing it to loop.

--%--
From: rodarima
Date: Mon, 11 Aug 2025 13:31:49 +0000

Oh, I see what may be going on:

https://github.com/dillo-browser/dillo/blob/b88506f619950640a7ea0dc3a1f615dc71068674/dpi/vsource.c#L127

That should be `%%` as otherwise is a printf format. It must be confusing musl.

--%--
From: mbuechse
Date: Mon, 11 Aug 2025 13:33:56 +0000

> That should be %% as otherwise is a printf format

I won't be able to build and test until the evening (in 5 hrs maybe). Then I could test this hypothesis as well, while I'm at it.

--%--
From: rodarima
Date: Mon, 11 Aug 2025 13:38:57 +0000

Thanks, I tested this on my old RPI 2 with Alpine and it seems to be the case:

```
berry:~$ cat a.c
#include <stdio.h>

int main()
{
	char buf[16];
	const char *fmt = "oops%;";
	int n = snprintf(buf, 16, fmt, "trash");
	printf("n=%d\n", n);

	return 0;
}
berry:~$ gcc a.c -o a
berry:~$ ldd ./a
	/lib/ld-musl-armhf.so.1 (0x76f72000)
	libc.musl-armv7.so.1 => /lib/ld-musl-armhf.so.1 (0x76f72000)
berry:~$ ./a
n=-1
```

It always fails with -1, so it assumes that is the old glibc behavior so it keeps expanding the buffer thinking that the problem is that it is not big enough.

I'll open a PR shortly.

--%--
From: mbuechse
Date: Mon, 11 Aug 2025 18:50:10 +0000

That was really quick. Thank you very much!