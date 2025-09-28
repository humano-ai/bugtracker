Title: use command -v instead of which
Author: ghost
Created: Thu, 03 Oct 2024 11:03:08 +0000
State: closed

Makes the build POSIX compliant by not using 'which'

--%--
From: ghost
Date: Thu, 03 Oct 2024 11:10:12 +0000

@Kangie @eli-schwartz
This should fix the issue with 'which'

--%--
From: rodarima
Date: Thu, 03 Oct 2024 19:38:49 +0000

Thanks Alex. Merging with capitalized "Use" in the commit message.

--%--
From: rodarima
Date: Thu, 03 Oct 2024 19:41:42 +0000

Merged here: https://github.com/dillo-browser/dillo/commit/9880c1ba603a6080b2493c7c399ae36d656a9834

--%--
From: eli-schwartz
Date: Sun, 06 Oct 2024 00:35:34 +0000

> @Kangie @eli-schwartz This should fix the issue with 'which'

I had pointed out in the associated issue that this isn't really the correct fix, but oh well. :)

--%--
From: rodarima
Date: Sun, 06 Oct 2024 08:24:39 +0000

> I had pointed out in the associated issue that this isn't really the correct fix, but oh well. :)

The issue #262 states that the problem is that the configure uses which(1), which is not posix compliant and there is no dependency documented anywhere. Using `command -v` makes the configure process posix compliant, so it is one correct solution to the problem.

Additionally, it makes Dillo remove the dependency over which(1), so that is a bonus.

I'm aware of AC_PATH_PROG to search for programs, just it is not needed for this particular case.