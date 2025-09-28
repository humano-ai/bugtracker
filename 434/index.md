Title: Fix hidden form inputs
Author: rodarima
Created: Sun, 24 Aug 2025 16:30:17 +0000
State: closed

Handle display:none properly for form elements. This is specially notable in the wikipedia.

Fixes #433 

--%--
From: rodarima
Date: Sun, 24 Aug 2025 17:06:34 +0000

This is causing leaks due to elements being outside the tree. We need to find a way to clean them as well.

--%--
From: rodarima
Date: Sat, 30 Aug 2025 14:31:19 +0000

> This is causing leaks due to elements being outside the tree. We need to find a way to clean them as well.

Managed to avoid creating new Embed and Resource elements, so there is no need to release them.

Let's make sure the memory leaks are first detected and then fixed on the CI.

--%--
From: rodarima
Date: Sat, 30 Aug 2025 14:37:49 +0000

Fails as expected: https://github.com/dillo-browser/dillo/actions/runs/17344978575/job/49243747678?pr=434

>  ==== Total leaks after filter: 51 ====

--%--
From: rodarima
Date: Sat, 30 Aug 2025 20:41:02 +0000

No leaks detected, seems to be working fine now.