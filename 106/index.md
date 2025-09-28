Title: Merge some patches from Livio Baldini
Author: rodarima
Created: Thu, 28 Mar 2024 18:28:17 +0000
State: closed

From: https://www.linux.ime.usp.br/~livio/dillo/

>- [save_scrolling_position.diff](https://www.linux.ime.usp.br/~livio/dillo/save_scrolling_position.diff) - (against 0.6.0) This adds a feature to Dillo. It records the last position the user scrolled to in a page, and when the user gets "Back" to that page, that position is used, instead of always going to the top!
>
>- [file.diff](https://www.linux.ime.usp.br/~livio/dillo/file.diff) - (against 0.3.0) This doesn't fix any bug, but fixes a Dillo behaviour which I consider to be wrong. When you type in an URL like:
>```
> /home/livio/
> ```
> Dillo will try to search for the server http://home/livio. I think this is wrong, instead dillo should "guess" this is a local file and try to resolve file:/home/livio.

[save_scrolling_position.diff.txt](https://github.com/dillo-browser/dillo/files/14793967/save_scrolling_position.diff.txt)
[file.diff.txt](https://github.com/dillo-browser/dillo/files/14793981/file.diff.txt)


--%--
From: ghost
Date: Sat, 05 Oct 2024 13:40:47 +0000

These patches are ancient and for the gtk version of Dillo. The first one I think is unnecessary since that feature is already implemented. The second one may be a dupe of issue #88, and would need to be completely re-written anyway. I suggest closing this issue.