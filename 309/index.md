Title: FLTK 1.4.0 problems with pixel units
Author: rodarima
Created: Sat, 23 Nov 2024 21:46:37 +0000
State: open

FLTK has now changed the positions and sizes from screen pixels to "units", which are scaled to have a consistent size across multiple DPI screens. This is causing several problems in Dillo. The most visible one is the horizontal glitches when scrolling. But there are several more.

Let's focus on the scrolling problem. After the page is rendered, there is a buffer on FLTK that holds the current pixels (screen pixels) in memory. When you scroll up or down, Dillo tries to be clever, and computes how much it needs to "shift" the current canvas so that it can reuse that portion and doesn't need to re-render it again. This is good for performance.

The way in which we do that is by calling the fl_scroll() FLTK function. BUT, we use FLTK units to instruct how much we need to shift the screen. This is internally translated into pixels, and then calls XCopyArea on X11 or simply a memcpy/memmove on Wayland.

So far so good. The problem is that now we have a chunk of the screen that needs to be rendered with the actual page content. This is what is done by the draw_area function, which is a function pointer that FLTK will invoke on its own with the position and size that needs to be rebuild.

The problem is that this position doesn't match the hole that has been left by shifting the screen. I suspect this has something to do with the scale factor while translating from FLTK units to pixels. In my particular case, this leaves a 3 pixel line of missing content (which will simply show what it was there before).

This is the *main* problem. We can "solve" it by causing each scroll event to redraw the screen, but that would hurt the performance. It is better to find a way to solve this while we keep the nice "shift" trick.

The other problem is that fl_scroll will accumulate errors over time due to the transformation to integer positions after applying the scale value. This causes that after several scroll events (in the same direction) the content of the screen is no longer placed in the same position as it should be. And any attempt to interact with the elements, will cause a redraw of that particular element, making it visible out of place. We should avoid fl_scroll (or at least the way we use it now).

Another problem that we have is that we need to know the final size in screen pixels of some elements, like images. As we will render an image to the final dimensions, often from a much larger buffer. So it doesn't make a lot of sense that after we render the image at, say 96 DPI, FLTK scales it to, say 120 DPI, causing artifacts in the image, when we can just render it at 120 DPI from the start.

Similarly, lines are no longer trusted to have exactly an integer number of pixels wide. This causes links with underlines to have a random 1 or 2 pixel wide, leaving inconsistent line widths on the same page.

As an intemediate solution, we can force FLTK to always work at 96 DPI, which I presume it would keep the 1.3.* behavior, and then slowly start fixing those problems. So we can at least link Dillo with 1.4.0 without causing a mess, as I start to suspect that distributions will begin to adopt 1.4.0, replacing 1.3.10 "soon".

--%--
From: rodarima
Date: Sun, 24 Nov 2024 10:59:16 +0000

Running with 96 DPI doesn't seem to be enough. The text rendering is also different, and in my quick tests it seems to be worse than before. I'm not sure what is responsible. Here are two cases from lobste.rs at 8x:

![text](https://github.com/user-attachments/assets/a720eee2-5cce-4625-80d5-ce96537c0f45)

(Not an endorsement of Kubernetes)