Title: fix for gcc 10
Author: walley
Created: Tue, 24 Jan 2023 09:11:13 +0000
State: closed



--%--
From: rodarima
Date: Fri, 02 Jun 2023 10:39:37 +0000

Hi walley, thanks for the patch and sorry for the long delay, I have not 
used dillo for a while. I will test the gcc 10 fix with my current 
version (gcc 13.1.1).

Can you split the tbody implementation in another MR?

Best, Rodrigo.


--%--
From: rodarima
Date: Fri, 02 Jun 2023 11:04:48 +0000

>I will test the gcc 10 fix with my current version (gcc 13.1.1).

The `--enable-ssl` seems to be broken due to the API major upgrade in 
mbedtls:

```
../../../src/IO/tls.c:52:10: fatal error: mbedtls/net.h: No such file or directory
    52 | #include <mbedtls/net.h>    /* net_send, net_recv */
```

It is taking the headers from mbedtls 3 instead of from the 2:

```
% pacman -Ql mbedtls | grep net.h
% pacman -Ql mbedtls2 | grep net.h
mbedtls2 /usr/include/mbedtls2/mbedtls/net.h
```

I'll try to build without SSL.


--%--
From: rodarima
Date: Fri, 02 Jun 2023 11:26:45 +0000

Merged with 4d35673f69d837db894305f3b3b618a26d0277c7

--%--
From: walley
Date: Fri, 02 Jun 2023 14:12:32 +0000

that tbody patch should not be here, i pushed it to wrong branch