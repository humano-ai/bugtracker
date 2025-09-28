Title: GIF animation support
Author: rodarima
Created: Sun, 08 Nov 2020 10:48:30 +0000
State: closed

Can we add GIF support for animation? Here is a test: http://www.lcdf.org/gifsicle/logo.gif

--%--
From: rodarima
Date: Sun, 08 Nov 2020 12:19:03 +0000

One way may be to allow external programs to be executed when opening certain files. For example we can run mpv from a dpi filter using something like `dpi:/mpv/:http://www.lcdf.org/gifsicle/logo.gif`

This would allow all kinds of formats available into libmpv, and we don't clutter the rendering mechanism in dillo.

See [plumb](http://man.cat-v.org/plan_9/6/plumb) and [rifle](https://github.com/ranger/ranger/blob/master/ranger/config/rifle.conf). These tools could also handle hard-to-scrape websites such as youtube.

So, let's generalize this issue in a general url opener.