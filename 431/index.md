Title: Fix internal page leak
Author: rodarima
Created: Tue, 12 Aug 2025 18:31:03 +0000
State: closed

A copy of the buffer is done while injecting the content for about:cache and about:dicache, so the Dstr needs to be free'd after.