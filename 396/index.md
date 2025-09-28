Title: Don't use assert to check if realloc() failed
Author: rodarima
Created: Sat, 10 May 2025 19:05:55 +0000
State: closed

Avoid using assert as when building with NDEBUG defined they become a no-operation so the realloc is never done. Always perform the check and exit accordingly.