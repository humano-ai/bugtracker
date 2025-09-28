Title: Add content tree inspector
Author: rodarima
Created: Tue, 26 Dec 2023 15:52:46 +0000
State: open

In order to debug some layout problems, we need to be able to see the internal widget tree and probably the related DOM. Currently Dillo discards the HTML as it is being processed (which is good for low memory devices), but we need to be able to run in debug mode in which the DOM is stored in memory and mapped to the widget tree to allow easier debugging. This would probably also open the door to tests which can assert properties of the tree directly.

I'm thinking in something similar to Firefox/Chrome where I can explore the widget tree and query properties of each Textblock by selecting it interactively. We can also add a box on top to mark the widget in the canvas or blink the background color to locate it.

I have done a proof of concept, but it should be designed to avoid querying internal members from outside, and instead let each widget report their own internal state in a common way.

![debug-window2](https://github.com/dillo-browser/dillo/assets/3866127/a8f2d41b-b662-4ba8-8cae-14bcc95169f7)


--%--
From: rodarima
Date: Sun, 03 Mar 2024 17:41:24 +0000

We are starting to have too many problems where this tree view is required to fix them. So let's include this in the 3.1 milestone, so we can debug problems in the wild too.

--%--
From: rodarima
Date: Thu, 07 Mar 2024 21:51:21 +0000

I splitted the tree into two panels, so we can see the document nodes in the left side and the properties on the right. Clicking on any part of the page with <kbd>Ctrl + Right Click</kbd> causes the window to jump to that node (I may need to think a better combination). Resizing the browser window causes the values to be updated in real time, which is useful to identify changes.

I also added some printing helpers to see the CSS lenghts in human readable values as well as colors.

Here is an example of fltk.org:

![image](https://github.com/dillo-browser/dillo/assets/3866127/d62920f4-b86e-4f22-b965-5f9b5fb55eba)


--%--
From: rodarima
Date: Fri, 08 Mar 2024 22:42:07 +0000

The current solution I quickly put together uses the Fl_Tree widget from the FLTK library directly in the dw::core::Widget and other inherited classes. This breaks the nice separation of concerns of the dw::core and dw::fltk namespaces, where widgets are platform-agnostic and all platform specific implementations are handled in the dw::fltk namespace.

I need to find a way to keep FLTK away from dw::core first.

--%--
From: rodarima
Date: Mon, 01 Apr 2024 21:31:52 +0000

I won't add this on 3.1.0, as it requires storing part of the DOM into memory to remember which element belongs to which Widget, and that could cause performance or memory issues with large pages. Additionally, the event window should be merged too, as the widget tree cannot really help debugging on its own. So let's leave this for another release, so we don't block 3.1.0 for longer.