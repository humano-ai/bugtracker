Title: Poll for dillo window during HTML tests
Author: campaul
Created: Sat, 24 May 2025 17:51:29 +0000
State: closed

This updates the html test driver to poll for the window instead of always waiting for a full second. It also continues to poll for much longer than 1 second. This accomplishes two things:

1) The tests will run faster on fast computers
2) The tests are now able to run on slower computers for which 1 second wasn't enough of a delay

--%--
From: rodarima
Date: Mon, 02 Jun 2025 21:47:05 +0000

I have a WIP patch to add a CLI tool to remote control Dillo which solves this problem by waiting until the page loads (or a timeout occurs). But we can merge this in the meanwhile. I'll need to check that all my old devices don't cause false negatives due to the reduction of the sleep time between the window appears and the rendering ends from 1 to 1/4 seconds.

--%--
From: rodarima
Date: Sun, 15 Jun 2025 14:06:19 +0000

I tested this on my old RPI 2 and it always fails unless the timeout is increased to at least 0.5 seconds (with 0.4 always fails). Here are the false negative rates I observed:

- 0.5 seconds -> 2% failure rate (15/754 executions)
- 1.0 second -> 0% failure rate (0/563 executions)

I suggest leaving it at 1 second but allowing developers to lower it by setting a `DILLO_TEST_WAIT_TIME` variable, so you can reduce it if you have faster hardware. This is just a temporary measure until we add support for a proper method that waits until the rendering is completed.

```diff
From dbcaa28c3dc12f70d6b44344693dc204327baa5a Mon Sep 17 00:00:00 2001
From: Rodrigo Arias Mallo <rodarima@gmail.com>
Date: Sun, 15 Jun 2025 15:58:47 +0200
Subject: [PATCH] Set test wait time to 1 second but allow override

Use the environment variable DILLO_TEST_WAIT_TIME to lower the default
time to wait since dillo window appears and when we take the screenshot
to compare the rendering output.
---
 test/html/driver.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/html/driver.sh b/test/html/driver.sh
index 76e3b2ef..07a78b84 100755
--- a/test/html/driver.sh
+++ b/test/html/driver.sh
@@ -42,7 +42,7 @@ function render_page() {
     if [ ! -z "$winid" ]; then
       found_window=true
       # Wait some after the window appears to ensure rendering is done
-      sleep 0.25
+      sleep ${DILLO_TEST_WAIT_TIME:-1}
       break
     fi
   done
--
2.49.0
```

--%--
From: rodarima
Date: Sun, 29 Jun 2025 12:06:15 +0000

Thanks, I'll rebase and merge this first. It is also failing with newer Image Magick versions as they now print two values in the compare output. But I will address that in another MR.