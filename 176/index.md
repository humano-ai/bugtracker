Title: tests: add HTML test items to EXTRA_DIST
Author: Kangie
Created: Fri, 31 May 2024 23:36:00 +0000
State: closed

This will enable tests to be easily run by downstream distributions.

These files are not included in the 3.1.0 release tarball, resulting in errors like:

```
make[4]: Entering directory '/var/tmp/portage/www-client/dillo-3.1.0/work/dillo-3.1.0/test/html'
make[4]: *** No rule to make target 'render/b-div.html', needed by 'render/b-div.html.log'.  Stop
```

When distributions try to package and test the software.

--%--
From: rodarima
Date: Sat, 01 Jun 2024 11:16:46 +0000

Thanks! I was not planning on adding the rendering tests in the release, as they may increase a lot the tarball size, but as we don't have many tests so far, the size increase is not too big:
```
% ls -l releases/dillo-3.1.0.tar.gz git/release/dillo-3.1.0.tar.gz
-rw-r--r-- 1 ram ram 1275663 Jun  1 11:43 git/release/dillo-3.1.0.tar.gz
-rw-r--r-- 1 ram ram 1198855 Jun  1 11:42 releases/dillo-3.1.0.tar.gz
```
So I will add them for now, and if we see the tarball size gets too big we may need to create a minimal release tarball without them (still fits in a floppy disk).

--%--
From: rodarima
Date: Sat, 01 Jun 2024 11:38:37 +0000

Hmm, I tested you patch, but it seems to be still failing. The tests are included in the tarball, but they are not found by make check. I'll try to add a test to the CI so it fails there too, as `make distcheck` doesn't enable the tests by default.

--%--
From: rodarima
Date: Sat, 01 Jun 2024 11:48:22 +0000

Tried to push my CI commit into your branch but GitHub closed the PR when I accidentally pushed our master branch, so I cannot update it now. I'll create another PR using this branch: https://github.com/dillo-browser/dillo/tree/make-distcheck-html-tests.

--%--
From: Kangie
Date: Sun, 02 Jun 2024 23:05:08 +0000

> Thanks! I was not planning on adding the rendering tests in the release, as they may increase a lot the tarball size, but as we don't have many tests so far, the size increase is not too big:
> 
> ```
> % ls -l releases/dillo-3.1.0.tar.gz git/release/dillo-3.1.0.tar.gz
> -rw-r--r-- 1 ram ram 1275663 Jun  1 11:43 git/release/dillo-3.1.0.tar.gz
> -rw-r--r-- 1 ram ram 1198855 Jun  1 11:42 releases/dillo-3.1.0.tar.gz
> ```
> 
> So I will add them for now, and if we see the tarball size gets too big we may need to create a minimal release tarball without them (still fits in a floppy disk).

Thanks for merging!

Consider switching to xz for compression, it's widely available and will give you a little more breathing room with that hard limit. :)