Title: DNS blocks in non-threaded mode
Author: rodarima
Created: Sun, 02 Mar 2025 19:36:17 +0000
State: open

We may want to consider bringing a truly non-blocking DNS implementation instead of relying on getaddrinfo() which will block the thread and lock the UI when the threading mode is disabled. This also makes Dillo require support for threads when we could drop it completely.

Newer alternatives like getaddrinfo_a() just do what we already do but requiring a much modern glibc.

See: https://c-ares.org/