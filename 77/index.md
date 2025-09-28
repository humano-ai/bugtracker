Title: Respect Cache-Control header to ignore cached version
Author: rodarima
Created: Sat, 10 Feb 2024 10:31:00 +0000
State: open

When following some of the sorting links of https://bluedwarf.top/cackle/index.php Dillo goes back to the index without re-fetching the new sorted content. The Cache-Control header should be tested determine if Dillo should to fetch again for new content.

--%--
From: Jullyfish
Date: Mon, 30 Jun 2025 10:00:42 +0000

And also doesn't work the header:
```
Expired: 0
```