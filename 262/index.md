Title: Configure uses `which` which is not POSIX compliant
Author: Kangie
Created: Tue, 01 Oct 2024 01:16:01 +0000
State: closed

## Issue

```
checking FLTK 1.3... yes
checking whether to link to X11... yes
checking for jpeglib.h... yes
checking for jpeg_destroy_decompress in -ljpeg... yes
checking for zlib.h... yes
checking for zlibVersion in -lz... yes
checking for libpng-config... ./configure: line 7202: which: command not found
./configure: line 7204: which: command not found
./configure: line 7207: which: command not found
```

`which` is not listed as a required command by POSIX and should be replaced by `command -v`.

See also: https://bugs.gentoo.org/940568

## Reproducing

Attempt to configure dillo on a machine without `which`.

## Resolution

Exorcise `which` from the codebase.

Examples:

https://github.com/dillo-browser/dillo/blob/4f303337cdf3d86b69918a137db19351cdbae581/autogen.sh#L18

https://github.com/dillo-browser/dillo/blob/4f303337cdf3d86b69918a137db19351cdbae581/configure.ac#L298-L313


--%--
From: Kangie
Date: Tue, 01 Oct 2024 01:19:19 +0000

Would you accept a PR that switched to the `meson` build system rather than patching autotools?

It will prove to be more maintainable, will eliminate this issue entirely, and in terms of 'needs to run anywhere' there are [muon](https://github.com/muon-build/muon) and [samurai](https://github.com/michaelforney/samurai) which are C99 implementations of Meson and Ninja respectively.

--%--
From: Kangie
Date: Tue, 01 Oct 2024 01:21:29 +0000

Re:

https://github.com/dillo-browser/dillo/blob/4f303337cdf3d86b69918a137db19351cdbae581/configure.ac#L298-L313

If autotools is to be retained this whole section (and the checks afterwards) could be trivially simplified to 'query pkg-config'.

--%--
From: rodarima
Date: Tue, 01 Oct 2024 17:08:23 +0000

I commented on the meson build in the PR. Let's keep this issue to solve *only* the problem of removing `which` to `command -v`, which should be fairly easy to do.

We don't have a build dependency over `pkg-config`, so I don't think this particular problem needs to pull it.

--%--
From: eli-schwartz
Date: Tue, 01 Oct 2024 23:19:23 +0000

Instead of using `command -v`, there is preexisting code earlier in this file:
```m4
AC_PATH_PROG(FLTK_CONFIG,fltk-config)
```

indicating the correct way to check for a program while respecting pre-set environment variables, is already known.

> We don't have a build dependency over `pkg-config`, so I don't think this particular problem needs to pull it.

"which" isn't the problem that is solved by using pkg-config. You still have to check for and find `pkg-config` as well.

The problem that is solved by using pkg-config is the cross-compilation problem. :) There are plenty of other dependencies that can use the same treatment... openssl, zlib, jpeg...

--%--
From: eli-schwartz
Date: Tue, 01 Oct 2024 23:20:47 +0000

It's possible to check pkg-config first and fall back to foobar-config programs only when that fails.

--%--
From: rodarima
Date: Wed, 02 Oct 2024 05:15:08 +0000

> ...indicating the correct way to check for a program...

The `which` command is not needed, so I prefer to switch to `command -v` which should be available in a POSIX shell.

> The problem that is solved by using pkg-config is the cross-compilation problem

Then I recommend you address it in another issue. I think this may also help #258 and #34. It would be nice to have a cross-compilation build in the CI, but I'm not sure if I know how to set it up.

--%--
From: rodarima
Date: Thu, 03 Oct 2024 19:43:02 +0000

Fixed in https://github.com/dillo-browser/dillo/commit/9880c1ba603a6080b2493c7c399ae36d656a9834