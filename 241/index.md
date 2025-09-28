Title: Round CSS value after applying zoom level
Author: rodarima
Created: Sun, 11 Aug 2024 20:24:41 +0000
State: closed

When a 1px value is used for the border, any zoom level that makes it
smaller makes the resulting size 0, so it disappears. Using round
instead leaves more room for zooming out before it disappears.

Fixes: https://github.com/dillo-browser/dillo/issues/240
