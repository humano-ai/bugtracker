Title: Remove libgif dependency from docs
Author: rodarima
Created: Wed, 10 Apr 2024 19:33:26 +0000
State: closed

The libgif library is not needed as Dillo has a builtin GIF support.

Fixes: https://github.com/dillo-browser/dillo/issues/128
Reported-by: dogma

--%--
From: rodarima
Date: Wed, 10 Apr 2024 19:46:13 +0000

Windows build failing due to cygwin.com [being down](https://github.com/cygwin/cygwin-install-action/issues/9#issuecomment-2048176827):
> There is some sort of incident with sourceware connectivity presently: https://fosstodon.org/@sourceware/112247941377987967