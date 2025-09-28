Title: Cannot load www.washingtonpost.com
Author: rodarima
Created: Sat, 19 Oct 2024 09:41:02 +0000
State: closed

Aparently https://www.washingtonpost.com/ doesn't load on Dillo, Curl or W3M. It does on Firefox. They seem to be banning us, but let's double check it is not on our end.

--%--
From: rodarima
Date: Sat, 19 Oct 2024 15:59:12 +0000

We can only access it if all the following hold:

- We use HTTP/2 (not supported in Dillo)
- Compressed with accept-encoding (already being done)
- They like the user agent (no curl, Dillo/ver is ok)



--%--
From: rodarima
Date: Sat, 19 Oct 2024 16:21:25 +0000

Reported to The Washington Post. Other than that, not much we can do until we implement support for HTTP/2, so closing for now.

--%--
From: rodarima
Date: Mon, 28 Oct 2024 07:49:32 +0000

No reply, but... instead of allowing HTTP/1.1 for Dillo, they just banned the User-Agent. Now both HTTP/1.1 or HTTP/2 won't work unless we mimick Mozilla et al.

Ticket #3948239.