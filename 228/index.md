Title: Copy and paste don't work
Author: marchuffnagle
Created: Fri, 19 Jul 2024 01:08:20 +0000
State: closed

I'm running Dillo version 3.1.1 (installed from the .deb file) in Xfce on Debian. If I try to copy or paste text in the URL bar, or copy text from the page, it does not work. I'm using `C-c` and `C-v`.

--%--
From: marchuffnagle
Date: Fri, 19 Jul 2024 01:14:08 +0000

I see from [the docs](https://dillo-browser.github.io/user_help.html#copy-and-paste) that it _can_ be done, but not in the way that I (as a random user) would have expected. Would it be possible to add support for using the system's copy and paste functionality?

--%--
From: rodarima
Date: Fri, 19 Jul 2024 18:05:47 +0000

Control+V seems to be working fine for me, I suspect the problem is that Control+C is not copying anything to the clipboard, which is a bug.

#### Details

There are two "clipboards" called selections in Xorg parlance: https://wiki.archlinux.org/title/clipboard#Selections

> - PRIMARY
>     Used for the currently selected text, even if it is not explicitly copied, and for middle-mouse-click pasting. In some cases, pasting is also possible with a keyboard shortcut.
> - CLIPBOARD
>     Used for explicit copy/paste commands involving keyboard shortcuts or menu items. Hence, it behaves like the single-clipboard system on Windows. Unlike PRIMARY, it can also handle [multiple data formats](https://stackoverflow.com/questions/3571179/how-does-x11-clipboard-handle-multiple-data-formats).

In Dillo, ideally you should be able to use both. When you select anything it gets copied into the "primary" selection, which you can paste pressing the middle button or wheel (also Shift+Insert). 

The "clipboard" selection is the one people outside UNIX are most used to, and works with the Control+C / Control+V shortcuts. On Dillo web forms and in the location bar, this seems to be working fine. The problem is when a chunk of text is selected from the page text and copied with Control+C which doesn't do anything right now, but should also place the text in the "clipboard" selection so it can be pasted with Control+V.

Regardless, Dillo has a history of encouraging users to use the "primary" selection where only the middle mouse button is required to paste. Middle clicking the red X on the location bar causes the "primary" selection to be opened as URL, see https://dillo-browser.github.io/user_help.html#location-bar. Copying any link via the context menu will place it in the "primary" selection, not in the "clipboard", so it won't be available via Control+V.

