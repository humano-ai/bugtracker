Title: Limit memory usage for cache and dicache
Author: Rodrigo Arias Mallo
Created: Fri, 19 Dec 2025 19:12:09 +0100
State: open

When browsing a page with several images on a low memory machine, it may happen
that the decompressed sizes of all images exceed the available memory, causing
major swapping of pages which would make Dillo and the whole system slow. In
that case, the user should be able to indicate a limit that should not be
exceeded by default to load images (when `load_images` is set to YES).

Similarly, we have an ever increasing cache for page resources (HTML, compressed
images, CSS, ...) which is never freed until the browser is closed. This
behavior is generally convenient when the network is expensive but the RAM is
not. In the opposite scenario, we want to remove elements from the cache after a
given limit so we keep the cache under control.

By far, the dicache is the largest problem, as decompressed images take much
more memory than any other resource, even after hours of browsing.

To implement a dicache limit, we first need to identify at which point we have
enough information to stop further images from decompressing. When we are
parsing `<img>` tags from the HTML page, there is no information yet on the
image dimensions, so we cannot infer which size they will need after
decompression.

Worse, it may happen that we are in the middle of the decoding of several images
and we pass the image cache limit. At that point, we either discard the decoded
image so far or we continue the decoding exceeding the limit. I would be
inclined to go the safe route and abort any current decoding as soon as we reach
the cache limit. At that point, only images that are requested by clicking with
the mouse are decoded.

We could use `a_Dicache_write()`.
