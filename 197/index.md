Title: Fix segfault in Done button of downloads
Author: rodarima
Created: Wed, 12 Jun 2024 19:26:13 +0000
State: closed

The destructor was using a harcoded index to the elements to free from the original array of arguments used to call the wget program. When the user agent was introduced, the index of the elements that require free() shifted, causing the free() call to operate on the constant string of the user agent instead.

Rather than relying on the hardcoded index, two new pointers hold the values of the strings that need to be free()'d in the destructor. Further additions in the argument array won't cause more problems.

Reported-by: pastebin
Fixes: https://github.com/dillo-browser/dillo/issues/196
See: https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/message/IPWQYKTYTO5G2BH3UU5224FRUFWCVGSO/