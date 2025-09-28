Title: use `magick` instead of `convert` if available
Author: Kangie
Created: Tue, 12 Nov 2024 06:20:45 +0000
State: closed

This suppresses a warning on more modern systems while preserving the ability of older systems and CI/CD to run the test suite.

> WARNING: The convert command is deprecated in IMv7, \
> use "magick" instead of "convert" or "magick convert"

--%--
From: rodarima
Date: Wed, 13 Nov 2024 17:45:58 +0000

Thanks!