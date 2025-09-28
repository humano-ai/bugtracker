Title: Navigate with keyboard only
Author: rodarima
Created: Tue, 13 Aug 2024 14:51:04 +0000
State: open

While the mouse is often convenient to navigate the web, it may be doable to use
the keyboard only as well.

We already support controlling the viewport position with configurable keys, so
HJKL navigation is posible. Similarly, switching tabs or going back and forward
in time.

The missing piece is to be able to follow hyperlinks with the keyboard too.

One approach may be to follow a bit the Tab behavior for forms. But as
hyperlinks may be scattered all around the viewport, I'm thinking in a better
solution.

Instead of pressing Tab several times to jump to the next element, we press a
key once to enter a "selection mode". In this mode, the HJKL keys no longer move
the viewport, but allow the user to navigate in 2D jumping across the hyperlinks
in the screen towards the direction determined by the HJKL keys (or arrow keys).

Once the hyperlink is found, it is just opened by pressing enter (or space) and
the view may reset the mode to the normal navigation mode.

We probably would need to define a formal ordering of hyperlinks, so all can be
reached from any other hyperlink with a finite sequence of HJKL movements.

This mechanism is more intuitive than tagging hyperlinks and having to type the
specific label for the one to open next. As the brain doesn't need to process
any label, it can preload a chain of operations and adjust it in case the
selection chain is going off-course.

No more Tab Tab Tab.


--%--
From: bohwaz
Date: Sun, 18 Aug 2024 00:14:20 +0000

Opera (Presto) had this, and Vivaldi has it as well, but it seems to work a bit worse than in Opera. They both use Shift+arrows.

https://blog.codinghorror.com/spatial-navigation-and-opera/
https://help.vivaldi.com/desktop/shortcuts/spatial-navigation/

--%--
From: rodarima
Date: Sun, 18 Aug 2024 00:33:26 +0000

> Opera (Presto) had this, and Vivaldi has it as well, but it seems to work a
> bit worse than in Opera. They both use Shift+arrows.

Nice to know!

I'm not sure which method will be easier to use. Coming from vim I would
personally choose the two modes approach (normal navigation vs link select) and
then just reuse the HJKL in the middle row for both.

I'll have to do some experiments when I implement this to test it. I suspect it
could be made configurable in keysrc to fit the user preferences.


--%--
From: khlsvr
Date: Sun, 01 Sep 2024 21:41:20 +0000

Would it be making dillo too heavy to use "link hinting"? Qutebrowser and some other keyboard-driven browsers use this method and it's really useful. 

Depending on the key I press I use it to: open link in same tab, open link in new tab, copy URL of the link, open the link in mpv etc. Many qutebrowser users use it all the time, but yeah maybe it's not that simple to implement it into Dillo?

--%--
From: rodarima
Date: Sun, 01 Sep 2024 22:14:48 +0000

>Would it be making dillo too heavy to use "link hinting"? Qutebrowser 
>and some other keyboard-driven browsers use this method and it's really 
>useful.
>
>Depending on the key I press I use it to: open link in same tab, open 
>link in new tab, copy URL of the link, open the link in mpv etc. Many 
>qutebrowser users use it all the time, but yeah maybe it's not that 
>simple to implement in Dillo?

It is probably doable, but let's focus first on having a simple and 
working implementation for link selection with arrows and then the rest.


--%--
From: khlsvr
Date: Mon, 02 Sep 2024 11:53:43 +0000

> It is probably doable, but let's focus first on having a simple and working implementation for link selection with arrows and then the rest.

I must have been tired last night as I didn't notice you already mentioned my proposed method in the original post. You could be right too with the extra brain processing with the labels but maybe I have gotten used to it so I haven't thought about it so much. 

Also I haven't tried the hjkl-arrows approach planned here. Maybe it could turn out to be a better way to pick the hyperlinks in dillo. 

Would it make sense to add the following extra behaviour on your hjkl-arrows approach when implementing it, or left out at first and consider it later. Often times people want to open the link in the current tab and also often times they want to open it in a new tab. Also often you just want to copy the URL of the link. So I'm thinking if "enter" is the default key for opening the selected link in the current tab, should there be another key for opening it in a new tab or copying the URL to primary/clipboard? Best of course would be a configurable system where you could write in your keysrc what to do with the selected link and with what key. 