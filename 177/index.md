Title: Ensure the release tarball can run HTML rendering tests
Author: rodarima
Created: Sat, 01 Jun 2024 11:52:06 +0000
State: closed

This is a continuation of https://github.com/dillo-browser/dillo/pull/176 as I accidentally closed it while trying to add a commit to test the CI, and prevented me from updating it further.

Original comment by @Kangie:
> This will enable tests to be easily run by downstream distributions.
> 
> These files are not included in the 3.1.0 release tarball, resulting in errors like:
> 
> ```
> make[4]: Entering directory '/var/tmp/portage/www-client/dillo-3.1.0/work/dillo-3.1.0/test/html'
> make[4]: *** No rule to make target 'render/b-div.html', needed by 'render/b-div.html.log'.  Stop
> ```
> 
> When distributions try to package and test the software.

--%--
From: rodarima
Date: Sat, 01 Jun 2024 13:01:34 +0000

The render HTML files seem to be placed in the wrong subdirectory:
```
% tar tf dillo-3.1.0.tar.gz | grep render | head
dillo-3.1.0/test/html/render/
dillo-3.1.0/test/html/render/render/
dillo-3.1.0/test/html/render/render/pre-code.html
dillo-3.1.0/test/html/render/render/table-td-width-percent-img.html
dillo-3.1.0/test/html/render/render/pic.png
dillo-3.1.0/test/html/render/render/margin-auto.ref.html
dillo-3.1.0/test/html/render/render/span-padding.ref.html
dillo-3.1.0/test/html/render/render/max-width-div.ref.html
dillo-3.1.0/test/html/render/render/max-width-nested-div.ref.html
dillo-3.1.0/test/html/render/render/css-units.html
```