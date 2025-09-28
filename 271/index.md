Title: Protect the user against massive image loading
Author: rodarima
Created: Mon, 07 Oct 2024 20:31:15 +0000
State: open

Some news websites have a massive number of images, which are usually designed to be rendered at a reasonable size. However, a failure in parsing some of the constraints in the CSS rules may cause all images to render at a much higher size than intended. This situation causes a spike in CPU and memory usage which may fill all available memory. As a concrete example, in my computer it reaches 1 GiB of memory usage opening a single news page.

We should by default protect the user against this problem (but let them remove the restriction if desired). One option may be to cap the maximum image cache per page, so we stop loading more images if we already reached the limit.