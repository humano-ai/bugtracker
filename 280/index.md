Title: Only use full URL for HTTP proxies
Author: rodarima
Created: Wed, 16 Oct 2024 17:30:28 +0000
State: closed

When performing a HTTPS request over a HTTP proxy, a direct connection is made to the remote server, so the GET line will be received as is. Therefore we shouldn't send the full URL but just the path.

Fixes: https://github.com/dillo-browser/dillo/issues/279