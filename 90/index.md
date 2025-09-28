Title: Fix table with max-width and min-width
Author: rodarima
Created: Sat, 02 Mar 2024 21:04:19 +0000
State: closed

Fix #89 

--%--
From: rodarima
Date: Sun, 17 Mar 2024 12:25:06 +0000

It breaks another case where a widget with `width: auto` and `max-width: 9999px` gets a width larger than the viewport.

![image](https://github.com/dillo-browser/dillo/assets/3866127/f957e527-e723-440e-8e73-76bb70a8262c)

And similarly, it set the available width to `min-width` when `width` is set to auto:

![image](https://github.com/dillo-browser/dillo/assets/3866127/5d99b1f7-1bbd-4050-b6db-86dd7278a864)

I added both tests.