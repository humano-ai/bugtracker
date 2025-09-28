Title: Reload the current page on SIGUSR1 signal
Author: rodarima
Created: Fri, 25 Oct 2024 16:50:24 +0000
State: closed

Fixes: https://github.com/dillo-browser/dillo/issues/255

Known limitations: External CSS and images are not fetched again, refetching them again causes issues.

--%--
From: rodarima
Date: Fri, 25 Oct 2024 17:41:16 +0000

This only operates on the first tab, even if it is out of focus. Once the first tab is closed, reloading via the signal causes a crash.

We will need to operate only on the "current" tab. If we have multiple windows, I assume we either reload the current tab on all windows, or just one of them.

Let's reload all of them for now.