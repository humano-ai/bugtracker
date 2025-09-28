Title: Expand tilde to home directory in local URLs
Author: rodarima
Created: Sun, 18 Feb 2024 15:07:39 +0000
State: closed

Allows paths like `file:~/` and `file:~/.dillo/dillorc` to be opened by Dillo by expanding the tilde character `~` to the value of the `$HOME` environment variable.

Fixes: https://github.com/dillo-browser/dillo/issues/81