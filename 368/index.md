Title: Add .deps/ to .gitignore
Author: acmiyaguchi
Created: Tue, 18 Mar 2025 03:58:19 +0000
State: closed

The .deps folders are part of the build process and dirty git status. This ignores them in the project.

--%--
From: rodarima
Date: Wed, 19 Mar 2025 22:35:19 +0000

Please, do the build in a separate directory as mentioned [in the documentation](https://github.com/dillo-browser/dillo/blob/master/doc/install.md#from-git). I'll merge this regardless.