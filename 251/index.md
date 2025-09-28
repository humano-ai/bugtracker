Title: Fix Google search
Author: rodarima
Created: Sun, 18 Aug 2024 12:46:16 +0000
State: closed

- Switch to HTTPS for Google search
- Fix Google search by adding gbv=1 param
- Avoid Google consent dialog by denying it


--%--
From: rodarima
Date: Wed, 11 Sep 2024 18:18:53 +0000

Not sure if leaving `ucbcb=1` is safe, so let's address it in another PR.