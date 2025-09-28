Title: Build without asserts by default
Author: rodarima
Created: Sun, 13 Apr 2025 17:00:55 +0000
State: open

Asserts are not intended to be used in performance builds. We should first make sure that we can disable them safely and then add `-DNDEBUG` to the flags by default. We probably should add a `--enable-debug` which also controls thhe optimization levels, debug information (-g) and leaving the frame pointer.

--%--
From: rodarima
Date: Sun, 13 Apr 2025 17:03:58 +0000

My eyes...

https://github.com/dillo-browser/dillo/blob/b804f4a6a3950fb13342e687acfa51b5c2157625/lout/container.cc#L139-L147

--%--
From: rodarima
Date: Sun, 13 Apr 2025 18:48:33 +0000

Introduced here: https://github.com/dillo-browser/dillo/commit/0856f155988da7dfc10eee25157525466ab32f20