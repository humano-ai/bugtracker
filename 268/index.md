Title: Navigation by pages
Author: rodarima
Created: Sun, 06 Oct 2024 09:23:04 +0000
State: open

The mouse wheel has become the main input method to read documents on the Web, which causes pages to scroll by small increments, often causing a spike of compute resources to keep the framerate high.

We still have "next page" and "previous page" shortcuts, but they cut the text at arbitrary positions. Dillo leaves a scroll step margin to avoid missing content, but this is not a very good solution.

On the other hand, ebook readers have a mechanism to paginate books and present them so that they fill a page, leaving margins all around.

I think it may be possible to use the same technique to render websites, so that we select a number of whole lines of text that fits in the page, including margins at the top and bottom, and then we cut the page there. This is essentially what "modern" browsers do nowadays when you try to print a page. They never cut a line in half.

If we are able to support such mechanism, maybe we can revert the spread of the mouse wheel and let the eyes rest from tracking the page moving around, as well as the CPU/GPU. It may also appear faster, as the next page will load immediately, rather than you having to wait until you slowly scroll to the next "page".

--%--
From: rodarima
Date: Sat, 12 Oct 2024 16:21:32 +0000

We may want to add another scroll mode in which we use the right and left mouse button to move to the next and previous page, respectively, regardless of at which side of the thumb the pointer has clicked. This is useful to focus on the text itself while leaving the mouse resting, and only click (ignoring the thumb location) to advance. The current problem now is that once the thumb reaches the mouse position, it won't continue to advance pages. It also makes moving to the previous page much easier.

The fast scrolling can still be implemented by detecting dragging. In fact we can potentially detect dragging at any position of the scrollbar, not only from the thumb, which would help if you are in a very long page and the thumb is very small.