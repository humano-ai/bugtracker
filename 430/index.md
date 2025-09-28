Title: Escape CSS % in printf format
Author: rodarima
Created: Mon, 11 Aug 2025 13:44:17 +0000
State: closed

The `%` symbol causes a printf format for `%;` which fails in musl, causing the loop in `dStr_vprintfa()` to continue expading the buffer.

Fixes: https://github.com/dillo-browser/dillo/issues/429