Title: Use memset() instead of bzero()
Author: rodarima
Created: Sun, 03 Mar 2024 17:32:21 +0000
State: closed

The bzero() function is removed in POSIX.1-2008.

Fixes: https://github.com/dillo-browser/dillo/issues/91