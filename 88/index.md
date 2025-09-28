Title: Resolve / and ~/ to local directories
Author: rodarima
Created: Sat, 02 Mar 2024 18:51:35 +0000
State: open

Currently they are resolving to http, which doesn't make much sense.

Commented-by: dogma

--%--
From: zzo38
Date: Tue, 02 Apr 2024 23:13:13 +0000

I would rather want a "relative mode". For example, if the current URL is `http://example.net/examples/42.html` and you type `/` then it will go to `http://example.net/` and if you type `~/` then it will go to `http://example.net/examples/~/`. It would do this with all URLs, not only those ones. If you include the scheme then it is an absolute URL. (I have managed to modify Firefox to work like this.)

--%--
From: rodarima
Date: Wed, 03 Apr 2024 09:49:40 +0000

> I would rather want a "relative mode". For example, if the current URL is `http://example.net/examples/42.html` and you type `/` then it will go to `http://example.net/` and if you type `~/` then it will go to `http://example.net/examples/~/`. It would do this with all URLs, not only those ones. If you include the scheme then it is an absolute URL. (I have managed to modify Firefox to work like this.)

I opened #119 to address this specific feature. This issue is to solve the problem of running:

```
$ dillo '~/'
```

And end up loading `http://~/`.

Loading paths that start with `/` already works from the command line, including only `/` (opens `file:/`). But not if opened directly from the location bar, which tries to load `http:/`.