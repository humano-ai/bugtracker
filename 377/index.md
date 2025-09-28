Title: Handle brotli encoding
Author: rodarima
Created: Sat, 05 Apr 2025 19:49:47 +0000
State: closed

Some pages don't respect the Accept-Encoding header and just return brotli encoding (br) regardless of what the client is asking for. One of such examples is https://www.justwatch.com/ (not that we will be able to load it properly anyway, but is an easy reproducer).

In the short term, we may want to issue a download instead of showing the raw bytes on the screen. On the other hand, we may be able to implement brotli decoding and get rid of this annoyance.