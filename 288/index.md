Title: Print the commit with dillo -v
Author: rodarima
Created: Tue, 22 Oct 2024 16:05:40 +0000
State: closed

When testing version of Dillo that are not released yet, it is convenient to see the exact commit they belong to. We can report this information by collecting it at the configure stage. Something like this:

```
% dillo -v
Dillo version 3.1.1 (commit 3480a9bb)
```