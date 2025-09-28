Title: Add workaround for OpenSSL in Cygwin
Author: rodarima
Created: Mon, 20 May 2024 19:21:40 +0000
State: closed

Cygwin doesn't seem to support detached threads used by the threaded DNS resolver at the same time the dynamic OpenSSL library is used. As a workaround we suggest disabling the threaded DNS (will use the same thread) if building with OpenSSL on Cygwin.

Fixes: https://github.com/dillo-browser/dillo/issues/172