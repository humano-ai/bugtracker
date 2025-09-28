Title: Use git commit in version if built from git
Author: rodarima
Created: Tue, 22 Oct 2024 18:23:30 +0000
State: closed

Attempts to fix #288 

I see at least one **big** problem:

```
$ git clone ... && cd dillo
$ ./autogen.sh # this will populate the version
$ mkdir build && cd build
$ ../configure && make # Okay, not we build dillo with the correct version
$ cd ..
$ $EDITOR src/...
$ git checkout -b foobar
$ git add ...
$ git commit -m foo
$ cd build
$ ../configure # <--- now we are placing the wrong version in dillo, as it was not updated in configure
```

So if I forget to run `./autogen.sh` again I get a fully working dillo binary with the wrong version.

This should run at configure time, not when running autoconf.

--%--
From: rodarima
Date: Mon, 09 Dec 2024 19:05:29 +0000

Closing in favor of #318 