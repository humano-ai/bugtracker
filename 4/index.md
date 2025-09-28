Title: build error, multiple definition of `xxxxxx'
Author: linsmod
Created: Mon, 17 Oct 2022 13:37:31 +0000
State: closed

```
gcc  -g -O2 -DD_DNS_THREADED -D_REENTRANT -D_THREAD_SAFE -Wall -W -Wno-unused-parameter -Waggregate-return  -L/usr/local/lib -o dpid  dpi.o dpi_socket_dir.o dpid.o dpid_common.o main.o misc_new.o ../dpip/libDpip.a ../dlib/libDlib.a 
/usr/bin/ld: dpi_socket_dir.o:/home/wulin/rodarima_dillo/dpid/dpid_common.h:43: multiple definition of `dpi_errno'; dpi.o:/home/wulin/rodarima_dillo/dpid/dpid_common.h:43: first defined here
/usr/bin/ld: dpid.o:/home/wulin/rodarima_dillo/dpid/dpid_common.h:43: multiple definition of `dpi_errno'; dpi.o:/home/wulin/rodarima_dillo/dpid/dpid_common.h:43: first defined here
/usr/bin/ld: dpid_common.o:/home/wulin/rodarima_dillo/dpid/dpid_common.h:43: multiple definition of `dpi_errno'; dpi.o:/home/wulin/rodarima_dillo/dpid/dpid_common.h:43: first defined here
/usr/bin/ld: main.o:/home/wulin/rodarima_dillo/dpid/dpid.h:58: multiple definition of `dpi_attr_list'; dpid.o:/home/wulin/rodarima_dillo/dpid/dpid.h:58: first defined here
/usr/bin/ld: main.o:/home/wulin/rodarima_dillo/dpid/dpid.h:61: multiple definition of `services_list'; dpid.o:/home/wulin/rodarima_dillo/dpid/dpid.h:61: first defined here
/usr/bin/ld: main.o:/home/wulin/rodarima_dillo/dpid/dpid_common.h:43: multiple definition of `dpi_errno'; dpi.o:/home/wulin/rodarima_dillo/dpid/dpid_common.h:43: first defined here
/usr/bin/ld: main.o:/home/wulin/rodarima_dillo/dpid/dpid.h:52: multiple definition of `numdpis'; dpid.o:/home/wulin/rodarima_dillo/dpid/dpid.h:52: first defined here
/usr/bin/ld: main.o:/home/wulin/rodarima_dillo/dpid/dpid.h:55: multiple definition of `numsocks'; dpid.o:/home/wulin/rodarima_dillo/dpid/dpid.h:55: first defined here
/usr/bin/ld: main.o:/home/wulin/rodarima_dillo/dpid/dpid.h:64: multiple definition of `sock_set'; dpid.o:/home/wulin/rodarima_dillo/dpid/dpid.h:64: first defined here
/usr/bin/ld: main.o:/home/wulin/rodarima_dillo/dpid/dpid.h:31: multiple definition of `srs_fd'; dpid.o:/home/wulin/rodarima_dillo/dpid/dpid.h:31: first defined here
/usr/bin/ld: main.o:/home/wulin/rodarima_dillo/dpid/dpid.h:28: multiple definition of `srs_name'; dpid.o:/home/wulin/rodarima_dillo/dpid/dpid.h:28: first defined here
/usr/bin/ld: misc_new.o:/home/wulin/rodarima_dillo/dpid/dpid_common.h:43: multiple definition of `dpi_errno'; dpi.o:/home/wulin/rodarima_dillo/dpid/dpid_common.h:43: first defined here
collect2: error: ld returned 1 exit status
make[2]: *** [Makefile:258: dpid] Error 1
make[2]: Leaving directory '/home/wulin/rodarima_dillo/dpid'
make[1]: *** [Makefile:263: all-recursive] Error 1
make[1]: Leaving directory '/home/wulin/rodarima_dillo'
make: *** [Makefile:180: all] Error 2
```

--%--
From: linsmod
Date: Mon, 17 Oct 2022 13:38:29 +0000

wulin@R7000:~/rodarima_dillo$ uname -a
Linux R7000 5.15.0-50-generic #56-Ubuntu SMP Tue Sep 20 13:23:26 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

--%--
From: linsmod
Date: Mon, 17 Oct 2022 13:38:53 +0000

gcc --version
gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

--%--
From: linsmod
Date: Mon, 17 Oct 2022 13:39:42 +0000

same error on master and release_3_0_5

--%--
From: rodarima
Date: Mon, 17 Oct 2022 17:31:38 +0000

Is probably due to the [changes in GCC 10](https://gcc.gnu.org/gcc-10/porting_to.html), try with `make CFLAGS=-fcommon`. The codebase should be properly patched to use `extern`.

--%--
From: linsmod
Date: Sat, 22 Oct 2022 10:41:08 +0000

got. fixed by use extern~ thanks ^_^