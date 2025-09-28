Title: Installation guide: building and plugins Makefile template
Author: tkapias
Created: Wed, 08 May 2024 16:54:24 +0000
State: open

The examples in the installation guide (doc/install.md) will install the config files in `/usr/local/etc/dillo`.

But most other tutorials and the Makefile template in every official plugins expect `/etc/dillo`.

The examples should be `../configure --prefix=/usr/local --sysconfdir=/etc`.

--%--
From: rodarima
Date: Wed, 08 May 2024 18:33:56 +0000

> The examples should be ../configure --prefix=/usr/local --sysconfdir=/etc.

Plugins should accept non-standard installation paths for /etc (including others than /usr/local/etc), so we don't need to pollute /etc with non-packaged files.

We can search in /etc and /use/local/etc for dpidrc by default for now.

Maybe also add a make variable so we can specify where to look for dpidrc to support other installation prefixes.