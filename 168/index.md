Title: Add support for Content-Disposition header
Author: rodarima
Created: Mon, 13 May 2024 22:16:23 +0000
State: closed

The Content-Disposition header defines the name of the file when downloading a file and is being used by GitHub for Dillo releases:

```
% curl -sLI https://github.com/dillo-browser/dillo/releases/download/v3.1.0/dillo-3.1.0.tar.gz | grep -i content-disposition:
content-disposition: attachment; filename=dillo-3.1.0.tar.gz
```

Otherwise, the default filename is something like this:
```
/tmp/866a6385-0be9-4636-8299-9bb2867298d3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetpr
```

https://datatracker.ietf.org/doc/html/rfc6266

--%--
From: rodarima
Date: Tue, 28 May 2024 21:16:48 +0000

Tests: http://test.greenbytes.de/tech/tc2231/

--%--
From: rodarima
Date: Thu, 01 May 2025 17:17:18 +0000

Closing as per #373. Full support of the Content-Disposition can be tracked in a new issue.