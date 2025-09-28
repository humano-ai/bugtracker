Title: Fix min-width and max-width CSS attributes
Author: rodarima
Created: Mon, 25 Dec 2023 00:42:44 +0000
State: closed

The calculation for the width was not taking into account the `min-width` and `max-width` attributes. Fixes #36.


https://github.com/dillo-browser/dillo/assets/3866127/5d5613f5-7023-4b92-b9a7-3e23d1a5ed00



I need to check that there is nothing else breaking, as there are no layout tests.

--%--
From: rodarima
Date: Mon, 25 Dec 2023 13:29:28 +0000

Still failing for `html {max-width: 600px}`:

![bad-html-max-width](https://github.com/dillo-browser/dillo/assets/3866127/de342167-c244-4791-8e78-d8fe94947698)


--%--
From: rodarima
Date: Mon, 25 Dec 2023 21:10:23 +0000

It is also failing for the body element, which is missing content:

![bad-body-max-width](https://github.com/dillo-browser/dillo/assets/3866127/a508c902-94d0-4f71-a55d-a05aa665ab26)


--%--
From: rodarima
Date: Tue, 26 Dec 2023 15:41:24 +0000

The problem seems to be caused by the body widget reporting a lineBreakWidth larger than the maximum constrained by the CSS style. I added a small debug window to compare both trees. On the left is the bad test with the body, and on the right the good one with the div.

![debug-window](https://github.com/dillo-browser/dillo/assets/3866127/3a61be3b-7da0-4045-93ae-3f7655ea76b7)

Which later causes the line break width of the div to be larger than it should be (600 px):

![debug-window2](https://github.com/dillo-browser/dillo/assets/3866127/17b03a35-df8a-418f-9c95-ac1421992113)


--%--
From: rodarima
Date: Sun, 31 Dec 2023 14:50:06 +0000

Added automatic tests:

```
make  check-TESTS
make[3]: Entering directory '/home/ram/dev/dillo/git/build/test/html'
make[4]: Entering directory '/home/ram/dev/dillo/git/build/test/html'
PASS: render/b-div.html
XFAIL: render/float-img-justify.html
XFAIL: render/img-aspect-ratio.html
FAIL: render/max-width-body.html
PASS: render/max-width-div.html
FAIL: render/max-width-html.html
PASS: render/max-width-nested-div.html
FAIL: render/min-width-body.html
PASS: render/min-width-div.html
FAIL: render/min-width-html.html
PASS: render/min-width-nested-div.html
PASS: render/table-thead-tfoot.html
PASS: render/white-space.html
============================================================================
Testsuite summary for dillo 3.1-dev
============================================================================
# TOTAL: 13
# PASS:  7
# SKIP:  0
# XFAIL: 2
# FAIL:  4
# XPASS: 0
# ERROR: 0
============================================================================
See test/html/test-suite.log
============================================================================
```

--%--
From: rodarima
Date: Sun, 31 Dec 2023 19:41:08 +0000

The problem with the min-width/max-width attributes in the html selector is that there is no Widget associated with the html tag that can hold the CSS style, it is only present for the body. It is also problematic as the styles are parsed *after* the html tag is opened, although there should be doable to update the HTML style and then finish the element when we open a body.

So far, the body is now fixed:

```
PASS: render/b-div.html
XFAIL: render/float-img-justify.html
XFAIL: render/img-aspect-ratio.html
PASS: render/max-width-body.html
PASS: render/max-width-div.html
FAIL: render/max-width-html.html
PASS: render/max-width-nested-div.html
PASS: render/min-width-body.html
PASS: render/min-width-div.html
FAIL: render/min-width-html.html
PASS: render/min-width-nested-div.html
PASS: render/table-thead-tfoot.html
PASS: render/white-space.html
============================================================================
Testsuite summary for dillo 3.1-dev
============================================================================
# TOTAL: 13
# PASS:  9
# SKIP:  0
# XFAIL: 2
# FAIL:  2
# XPASS: 0
# ERROR: 0
============================================================================
See test/html/test-suite.log
============================================================================
```

--%--
From: rodarima
Date: Sun, 31 Dec 2023 20:26:36 +0000

Let's leave the fix for the HTML element for another PR, as it would require more analysis.