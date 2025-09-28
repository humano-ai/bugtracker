Title: Ensure the same number of tags for CSS and HTML
Author: rodarima
Created: Fri, 07 Jun 2024 20:50:40 +0000
State: closed

The Tags array can be modified without changing the "ntags" number in the CSS side. To prevent errors, an static assert ensures the same number is used in both sides, which is known at compilation time.

Fixes: https://github.com/dillo-browser/dillo/issues/184