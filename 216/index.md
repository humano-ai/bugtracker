Title: Debian package
Author: rodarima
Created: Sun, 07 Jul 2024 09:33:01 +0000
State: open

Try to update the current Debian package, as it still is using the old 3.0.5 version which has TLS problems.

Here is a test package for Debian 12 (amd64 architecture): [dillo_3.1.1-1_amd64.deb.gz](https://github.com/user-attachments/files/16118717/dillo_3.1.1-1_amd64.deb.gz)

To install:

```sh
$ wget https://github.com/user-attachments/files/16118717/dillo_3.1.1-1_amd64.deb.gz
$ gunzip dillo_3.1.1-1_amd64.deb.gz
$ sudo dpkg -i dillo_3.1.1-1_amd64.deb
$ dpidc stop # To ensure we don't have any Dillo plugin running
```

--%--
From: ghost
Date: Sun, 07 Jul 2024 10:15:36 +0000

Looks OK on 12.6, installing through apt even pulls the correct dependency (libfltk1.3), I've tried a bunch of websites and it seems to be stable.

--%--
From: bbbhltz
Date: Sun, 07 Jul 2024 10:34:39 +0000

Also on 12.6 and it works on the websites I've tried.

--%--
From: rodarima
Date: Sun, 07 Jul 2024 19:05:15 +0000

(I'm waiting on the debian GitLab repository to activate my account so I can open a MR there)

--%--
From: rodarima
Date: Sat, 13 Jul 2024 10:37:00 +0000

Openned merge request on Debian: https://salsa.debian.org/debian/dillo/-/merge_requests/1

--%--
From: steinarb
Date: Sat, 13 Jul 2024 17:19:04 +0000

Running on 12.6 bookworm now.

CSS seems a clear improvement to [dillo 3.0.5-7](https://packages.debian.org/bookworm/dillo) but not yet good enough to handle https://gridbyexample.com/examples/page-layout/listing-with-thumbnails/ (most notably, the thumbnails are blown up to gigantic size: they get the width of the browser window).

I am trying to make https://oldalbum.bang.priv.no/ show something more interesting than "This page requires javascript" ([project described here](https://steinar.bang.priv.no/2022/02/12/1990-ies-picture-archives-in-modern-skin/))

I currently have something similar to the original https://www.bang.priv.no/sb/pics/ running but I was trying to style it up to look better but what I tried was maybe a bit advanced for dillo's current state.

Are there plans for CSS improvements? (should I remove the flexbox/grid formatting and try something simpler or is there radical improvements on the way for dillo?)

--%--
From: rodarima
Date: Sun, 14 Jul 2024 12:19:07 +0000

> Running on 12.6 bookworm now.
> ...

This issue is about updating the Debian package, I opened another one to discuss the CSS topic: https://github.com/dillo-browser/dillo/issues/223

--%--
From: steinarb
Date: Sun, 14 Jul 2024 13:18:48 +0000

> This issue is about updating the Debian package, I opened another one to discuss the CSS topic: #223

Thanks! This was mostly me thinking out loud.


--%--
From: arpinux
Date: Tue, 16 Sep 2025 12:30:26 +0000

hi,
dillo debian stable version cannot open debian.org website but your version (3.2.0) can open it successfully.
so i report this bug on debian, hoping someone could take your git version to build dillo for debian.
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1114901