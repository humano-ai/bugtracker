Title: Support for OpenSSL 1.1
Author: rodarima
Created: Sat, 23 Dec 2023 13:51:14 +0000
State: closed

We may want to add support for OpenSSL 1.1, as there are not that many changes and we can use some ifdefs to skip the differences.

In any case, the detection of OpenSSL should include new functions that are only in 3.x while we don't support OpenSSL 1.1, so we can detect an invalid version early. See #30.

--%--
From: rodarima
Date: Sun, 24 Dec 2023 16:05:46 +0000

Closed in #33 