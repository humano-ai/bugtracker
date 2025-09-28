Title: Add scroll_step option
Author: rodarima
Created: Wed, 20 Dec 2023 00:43:33 +0000
State: closed

When using the mouse wheel to scroll a page, the default scroll step was causing a very slow scrolling speed. The new option "scroll_step" allows the user to define how many pixels the page is moved in every step of the mouse wheel. The default is increased to 100 pixels per step.

Here is an example where a [large page](https://html.spec.whatwg.org/#a-quick-introduction-to-html) is loaded in the original Dillo in the left and the version with the increased scroll step to 100 in the right. When using the mouse wheel the screen is moved much faster now:

[video.webm](https://github.com/dillo-browser/dillo/assets/3866127/592b7d1c-b62a-492f-80ab-6bf3ded3689d)


Fixes #22 