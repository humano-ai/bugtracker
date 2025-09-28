Title: Fix webp and brotli status variable in configure
Author: rodarima
Created: Sun, 29 Jun 2025 13:04:23 +0000
State: closed

We are interested in webp_ok and brotli_ok which indicates if we can use webp or brotli. Even if the user specifies `--enable-webp` setting enable_webp to yes, if it is not found it won't be available.