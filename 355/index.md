Title: configure with IPv6 on by default
Author: sevan
Created: Sat, 08 Feb 2025 23:33:24 +0000
State: closed

Provide an argument to disable IPv6, inverting previous behaviour.

Realised that I had to enable IPv6 specifically when surfing on OS X 10.4.

--%--
From: rodarima
Date: Mon, 24 Feb 2025 17:41:35 +0000

Thanks, but this will cause a build failure in old machines that don't support IPv6, see https://github.com/dillo-browser/dillo/issues/167. I will eventually implement a detection mechanism, for now I'll keep it disabled.

We can add the `--enable-ipv6` flag in the [install notes for MacOS](https://github.com/dillo-browser/dillo/blob/master/doc/install.md#building-from-source-1) in the meanwhile.

--%--
From: rodarima
Date: Fri, 11 Jul 2025 20:49:13 +0000

I added support to detect IPv6 at build time, see https://github.com/dillo-browser/dillo/pull/419. In the CI with Mac OS 13 it detects it and enables as expected. May be a good idea to try it with Mac OS X 10.4 as well.

--%--
From: sevan
Date: Fri, 11 Jul 2025 20:50:57 +0000

Yep, no worries. Will take a look over the weekend and report back.