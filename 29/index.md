Title: Open file dialog pops up in /tmp and forgets opened file's dir when changing page
Author: rodarima
Created: Fri, 22 Dec 2023 22:20:00 +0000
State: open

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1036384

>When I pop up the Open file dialog it always opens in /tmp, forcing you
>to change to home, which is where it should open. The only exception is
>when you have already opened a file and are still displaying it, then it
>rightly opens in the same dir, but if you go back to another page and
>return it forgets.
>
>Besides, if I click on FLTK's shortcut for /, right up the Filename
>text entry, it only displays kernel fs dirs: sys, proc, dev, run, and
>subdirs of these.
>
>The whole issue is a very serious usability issue.

Agreed, I would expect it to either be in the last directory you used (this is specially painful if you are downloading 10 or more files, one by one) or let the user change the behavior and always start from a directory of users choice.

--%--
From: rodarima
Date: Fri, 22 Dec 2023 22:38:26 +0000

We can easily switch to the native file chooser, which would open something familiar to users. In my case is using the GTK file chooser (although I didn't care much to setup a proper theme):

![filechooser](https://github.com/dillo-browser/dillo/assets/3866127/2f273ec4-707d-4fa0-9418-6612df2741ac)

These choosers typically hold the last directories on their own.