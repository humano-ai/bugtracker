Title: [GCC15] error: passing argument 2 of a_Timeout_add from incompatible pointer type [-Wincompatible-pointer-types]
Author: Kangie
Created: Thu, 12 Dec 2024 07:02:53 +0000
State: closed

```
x86_64-pc-linux-gnu-gcc -DHAVE_CONFIG_H -I. -I..  -I.. -DDILLO_SYSCONF='"/etc/dillo/"' -DDILLO_DOCDIR='"/usr/share/doc/dillo-3.1.1/"' -DCUR_WORKING_DIR='"/var/tmp/portage/www-client/dillo-3.1.1/work/dillo-3.1.1/src"'   -I/usr/include/libpng16 -O2 -pipe -march=native -fno-diagnostics-color -DENABLE_I
cache.c: In function Cache_delayed_process_queue:
cache.c:1388:26: error: passing argument 2 of a_Timeout_add from incompatible pointer type [-Wincompatible-pointer-types]
 1388 |       a_Timeout_add(0.0, Cache_delayed_process_queue_callback, NULL);
      |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

See: https://bugs.gentoo.org/944457

--%--
From: rodarima
Date: Thu, 12 Dec 2024 19:21:44 +0000

Not sure what the problem is here:

```c
/* timeout.hh */
typedef void (*TimeoutCb_t)(void *data);
void a_Timeout_add(float t, TimeoutCb_t cb, void *cbdata);

/* cache.c */
static void Cache_delayed_process_queue_callback(void *ptr)
{
  /* ... */
}

static void Cache_delayed_process_queue(CacheEntry_t *entry)
{
   /* ... */
   a_Timeout_add(0.0, Cache_delayed_process_queue_callback, NULL);
   /* ... */
}
```

It is compiling ok on gcc trunk: https://godbolt.org/z/adPcq8G5d

(GCC 15 is not released yet)

Edit: Looking at the [logs](https://944457.bugs.gentoo.org/attachment.cgi?id=911544), it looks like a gcc bug:

```
cache.c: In function ‘Cache_delayed_process_queue’:
cache.c:1388:26: error: passing argument 2 of ‘a_Timeout_add’ from incompatible pointer type [-Wincompatible-pointer-types]
 1388 |       a_Timeout_add(0.0, Cache_delayed_process_queue_callback, NULL);
      |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                          |
      |                          void (*)(void)
In file included from cache.c:37:
timeout.hh:10:41: note: expected ‘TimeoutCb_t’ {aka ‘void (*)(void *)’} but argument is of type ‘void (*)(void)’
   10 | void a_Timeout_add(float t, TimeoutCb_t cb, void *cbdata);
      |                             ~~~~~~~~~~~~^~
make[3]: *** [Makefile:691: cache.o] Error 1
```

The argument `Cache_delayed_process_queue_callback` seems to me to have type `void (*)(void *)`.

--%--
From: rodarima
Date: Wed, 22 Jan 2025 17:11:32 +0000

Closing, cannot reproduce. Reopen with steps to reproduce if this is still an issue.

--%--
From: NHOrus
Date: Mon, 24 Feb 2025 13:48:25 +0000

Install GCC-15 or pass `-std=gnu23` to GCC-14 as a cflag

--%--
From: NHOrus
Date: Mon, 24 Feb 2025 13:58:37 +0000

C23 forbids K&R style incomplete function declarations like `int f()`, it recognizes such declaration as `int f(void)`
see https://en.cppreference.com/w/c/language/function_declaration

--%--
From: NHOrus
Date: Mon, 24 Feb 2025 14:05:13 +0000

Patch looks like somewhat like this: 
```
--- a/src/cache.c
+++ b/src/cache.c
@@ -1359,7 +1359,7 @@
 /**
  * Callback function for Cache_delayed_process_queue.
  */
-static void Cache_delayed_process_queue_callback()
+static void Cache_delayed_process_queue_callback(void *data)
 {
    CacheEntry_t *entry;
 
--- a/src/jpeg.c
+++ b/src/jpeg.c
@@ -124,7 +124,7 @@
  *    static void init_source(j_decompress_ptr cinfo)
  * (declaring it with no parameter avoids a compiler warning)
  */
-static void init_source()
+static void init_source(struct jpeg_decompress_struct *cinfo)
 {
 }
 
@@ -181,7 +181,7 @@
  *    static void term_source(j_decompress_ptr cinfo)
  * (declaring it with no parameter avoids a compiler warning)
  */
-static void term_source()
+static void term_source(struct jpeg_decompress_struct *cinfo)
 {
 }
```

--%--
From: NHOrus
Date: Mon, 24 Feb 2025 14:40:20 +0000

This patch is for 3.1.1 and not 3.2.0, 3.2.0 builds without problem.

Sorry about this.

--%--
From: rodarima
Date: Mon, 24 Feb 2025 17:24:16 +0000

Thanks, that explains why I couldn't reproduce the issue as I was using the tip of master while they were using the 3.1.1 release:

> Unpacking dillo-3.1.1.tar.bz2 to /var/tmp/portage/www-client/dillo-3.1.1/work

This should be fixed on 3.2.0 by 4d51150ca0aae979718ac10030df85421b763cd1.