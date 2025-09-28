Title: Dissapearing content in FLTK website
Author: rodarima
Created: Sun, 23 Jun 2024 13:06:36 +0000
State: closed

![fltk](https://github.com/dillo-browser/dillo/assets/3866127/48c326c3-3622-4db8-a903-9b2114a30136)


--%--
From: ghost
Date: Sat, 05 Oct 2024 10:37:37 +0000

This issue appears to be resolved, the site looks fine now.


--%--
From: rodarima
Date: Sat, 05 Oct 2024 11:17:44 +0000

Not sure if it is related, but I still trigger the infinite layout bug if I resize the window enough times:

```
>>>> a_Nav_repush <<<<
Nav_open_url: new url='https://www.fltk.org/'
IO_write, closing with pending data not sent: "GET /images/rss-feed-icon.png HTTP/1.1\x0D..."
a_Nav_expect_done: repush!
** ERROR **: Emergency layout stop after 1000 iterations
** ERROR **: Please file a bug report with the complete console output
** ERROR **: Emergency layout stop after 1000 iterations
** ERROR **: Please file a bug report with the complete console output
** ERROR **: Emergency layout stop after 1000 iterations
```

But let's cover that on https://github.com/dillo-browser/dillo/issues/236.