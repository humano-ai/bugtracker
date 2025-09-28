Title: Missing table content on resizing
Author: rodarima
Created: Mon, 08 Jan 2024 21:09:07 +0000
State: closed

When loading https://www.fltk.org/newsgroups.php?s21875+gfltk.coredev+v21894 without enabling any CSS and resizing the window to make it smaller some text is missing, but should be properly wrapped.

Reproduced on master with 95627efadf55c39901928ee730d22de55cdcc209 but not with 3.0.5.

Reported-By: dogma

--%--
From: rodarima
Date: Mon, 26 Feb 2024 23:24:03 +0000

Seems to be introduced by 6f66fd86, as well as #84 
```
6f66fd861ef1d1bd583c31c2ce3d9c4a9896ede1 is the first bad commit
commit 6f66fd861ef1d1bd583c31c2ce3d9c4a9896ede1
Author: Rodrigo Arias Mallo <rodarima@gmail.com>
Date:   Mon Dec 25 01:09:26 2023 +0100

    Fix bogus comparison of oofContainer[i]

    The same index was being used in both sides of the comparison.

 dw/textblock.cc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
```

> Reproduced on master with https://github.com/dillo-browser/dillo/commit/95627efadf55c39901928ee730d22de55cdcc209 but not with 3.0.5.

This is not consistent, I cannot reproduce it with 95627efa.