Title: The old std check doesn't fail if newer features are used
Author: rodarima
Created: Sun, 07 Jul 2024 16:52:41 +0000
State: closed

See https://github.com/dillo-browser/dillo/actions/runs/9818421298/job/27110999157#step:6:11

--%--
From: rodarima
Date: Sat, 13 Jul 2024 11:17:48 +0000

This seems to make it fail, but it also uncovers some other problems:
```
../configure 'CFLAGS=-std=c99' 'CXXFLAGS=-pedantic -std=c++98 -Werror=c++11-extensions'
```