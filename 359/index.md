Title: Text under scrollbar when placed on the left side
Author: rodarima
Created: Thu, 27 Feb 2025 21:28:01 +0000
State: closed

Reproducer: https://emreed.net/LowTech_Directory

![Image](https://github.com/user-attachments/assets/e656b5eb-88aa-47f0-8125-68b4006ec25b)

--%--
From: rodarima
Date: Thu, 27 Feb 2025 21:37:19 +0000

Simplified reproducer:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Test text under left scrollbar</title>
    <style>
    body { width: 700px; height: 1000px; }
    </style>
  </head>
  <body>
    <p>
      Can you read me?
      <em>You must set the scrollbar_on_left=YES config option</em>
    </p>
  </body>
</html>
```

--%--
From: rodarima
Date: Thu, 27 Feb 2025 22:25:58 +0000

Ah, I see. We first perform the layouting in one go, assuming the scrollbar is not needed and placing the content closer to the window border. Then the canvas ascent and descent is updated, triggering Layout::containerSizeChanged:

https://github.com/dillo-browser/dillo/blob/fbd719f93ab659fec6c42952e76f5e5b971728be/dw/layout.cc#L966-L972

https://github.com/dillo-browser/dillo/blob/fbd719f93ab659fec6c42952e76f5e5b971728be/dw/layout.cc#L1344-L1354

But this in turn never enters again inside the conditional:

https://github.com/dillo-browser/dillo/blob/fbd719f93ab659fec6c42952e76f5e5b971728be/dw/layout.cc#L928-L929

So the allocation.x is never updated:

https://github.com/dillo-browser/dillo/blob/fbd719f93ab659fec6c42952e76f5e5b971728be/dw/layout.cc#L947-L948

We cannot apply this optimization:

https://github.com/dillo-browser/dillo/blob/fbd719f93ab659fec6c42952e76f5e5b971728be/dw/layout.cc#L925-L929

As otherwise we will miss the case in which the canvas it too large when the toplevel widget has finished rendering. We need to trigger a toplevel resize as if the viewport has changed its size.

--%--
From: rodarima
Date: Thu, 27 Feb 2025 23:02:51 +0000

The toplevel widget will refuse to queue a resize if its own size is specified in absolute units:

https://github.com/dillo-browser/dillo/blob/fbd719f93ab659fec6c42952e76f5e5b971728be/dw/widget.cc#L456-L460

This is actually correct, as the size of the widget won't change. We only need to force the top level widget to re-allocate (compute the position of the tree in a different offset). We can just enable the NEEDS_ALLOCATE flag when we detect that the scrollbar was just enabled.

--%--
From: rodarima
Date: Thu, 27 Feb 2025 23:04:41 +0000

That seems to fix it. I will need to check we don't accidentally enter a loop of allocations, but it doesn't seem posible. It will trigger the emergency brake anyway.

![Image](https://github.com/user-attachments/assets/049bcbe4-9a47-4b54-8453-eca6e634f2e0)