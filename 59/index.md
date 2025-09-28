Title: Free SSL connection before closing file descriptor
Author: rodarima
Created: Sun, 14 Jan 2024 07:43:12 +0000
State: closed

Attempting to shutdown an SSL conection in LibreSSL was causing an error to be queued in the error queue, which was triggering the `assert(!ERR_get_error())` for a new connection. In OpenSSL this error was not queue in the "main" error queue, but only recorded for that SSL connection. so it was not triggering the assert.

The fix simply closes the file descriptor *after* performing the free operation.

@badsectoracula could you test this PR and check that fixes the #51 issue?

Fixes #51

--%--
From: badsectoracula
Date: Mon, 15 Jan 2024 09:48:49 +0000

I checked the branch and the bug seems to be gone, https sites load fine.

--%--
From: rodarima
Date: Mon, 15 Jan 2024 18:01:00 +0000

Thanks! I'll merge it then.