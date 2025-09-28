Title: dillo2 fails to load anything if started in xinit+tmux
Author: cschuber
Created: Sun, 13 Oct 2024 08:26:25 +0000
State: open

Copied from https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=282042:

Using xinit/startx to launch dillo leads to dillo only loading a couple of local files (Not tested with external websites). as in { dillo htmlfiles*.html }

After much testing I could reduce the number of hanging tabs but you still get some.

launching dpid first, dpidc register; and then launching dillo after sleeping for a while does lead to less hanging (I think)

So I ran

truss -fda -o /dev/stdout dpid | awk '1;/ERR#9/ {exit}' > dpid.truss.txt

which leads to an infinite close(n+1) ERR#9 bad file descriptor
with n=3

Making dillo unusable, so trying to debug it is worse.

Mind you, I can still use dillo fine, just not via xinitrc, even with sleeping.

--%--
From: rodarima
Date: Sun, 13 Oct 2024 11:17:37 +0000

Thanks for the report. I talked a bit with OP on IRC, but I cannot reproduce those hangs on Linux. Ideally I'll need a script that I can run that reproduces the hangs with some probability and/or a backtrace of dpid on that infinite loop.

On another topic, dillo 2 was based on FLTK 2.0, which [was discontinued](https://dillo-browser.github.io/old/news_old.html). You may want to rename www/dillo2 to www/dillo3 (or just www/dillo) and update to [3.1.1](https://dillo-browser.github.io/release/3.1.1/), althought it is unlikely this problem will be fixed on 3.1.1.