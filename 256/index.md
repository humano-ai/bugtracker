Title: Avoid expensive boundary search inside file
Author: rodarima
Created: Sun, 01 Sep 2024 22:23:26 +0000
State: closed

Prevents Dillo from checking if the boundary collides with the file by making the boundary have 70 random characters which have an extremely low probability of collision.

--%--
From: XaviDCR92
Date: Tue, 03 Sep 2024 20:39:45 +0000

Since the two later commits are modifying things implemented by the first commit on the PR, feel free to squash all of them into a single commit.

--%--
From: rodarima
Date: Mon, 09 Sep 2024 18:53:12 +0000

> Since the two later commits are modifying things implemented by the first commit on the PR, feel free to squash all of them into a single commit.

I think for this time I'm going to leave it in different commits, as they show the history of how we came with the current implementation and they also build fine.

Could you test it with slcl?

--%--
From: XaviDCR92
Date: Mon, 09 Sep 2024 21:00:16 +0000

Please take into account that the boundary string [would still be quoted](https://github.com/dillo-browser/dillo/blob/8a360e32ac3136494a494379a6dbbacef6f95da2/src/IO/http.c#L362) if no further changes are made. It might be a sensible idea to add an extra commit that removes the quoting from the `boundary`.

> Could you test it with slcl?

I have just tested this branch with `slcl` and it worked as expected, receiving `boundary=u6ngno8jWSmEjUQbfDwOpL8Wb4CWoPkJLyNWKK3usgYzYDA44UIjvE3wyvgLaqiJMVwktn` from Dillo.

--%--
From: rodarima
Date: Tue, 10 Sep 2024 05:02:14 +0000

> Please take into account that the boundary string [would still be quoted](https://github.com/dillo-browser/dillo/blob/8a360e32ac3136494a494379a6dbbacef6f95da2/src/IO/http.c#L362) if no further changes are made. It might be a sensible idea to add an extra commit that removes the quoting from the `boundary`.

Yes, I'm aware. It looks all major browsers as well as curl do it without quotes, so it should be fairly safe to change it, but let's address it in another PR. There is also another potential problem, as Dillo doesn't finish the last boundary delimiter with CRLF, although the RFC doesn't seem to state that it must be placed there.

> I have just tested this branch with `slcl` and it worked as expected, receiving `boundary=u6ngno8jWSmEjUQbfDwOpL8Wb4CWoPkJLyNWKK3usgYzYDA44UIjvE3wyvgLaqiJMVwktn` from Dillo.

Thanks!, I'll add it to the ChangeLog and merge it.