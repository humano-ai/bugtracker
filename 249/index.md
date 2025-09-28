Title: Allow users to empty the cache
Author: rodarima
Created: Sat, 17 Aug 2024 14:36:42 +0000
State: open

As a half-way implementation of #231, we could initially add a manual mechanism
to empty the cache. Adding an automatic mechanism would require storing some
score in the cache entries, while doing it manually is an easy patch.


--%--
From: rodarima
Date: Sat, 17 Aug 2024 17:18:46 +0000

There are several caches in Dillo. The one that seems to occupy the most is the
so called Dicache, which stores uncompressed image buffers. For reference,
loading Brutaldon takes around 100 MiB of uncompressed image size.

The Dicache has several reference counters to avoid removing buffers that are
still in use. Even after they are not used, they will survive three cleanup
attempts.

On the other hand, after closing the page with the images, and calling
`a_Dicache_cleanup()` doesn't seem to be enough to get rid of the cache entries.
Not sure if there are more references somewhere.

This should be easy to test, as we can make a page with large images, load it,
then open a new page without images, clear the cache and ensure the resident
memory usage goes to the initial level.

It doesn't look we are leaking those buffers when closing Dillo.

I have also tested clearing the "normal" cache, which just stores the compressed
images and other resources fetched by HTTP, but it doesn't seem to free that
much memory.


--%--
From: rodarima
Date: Sun, 18 Aug 2024 00:24:29 +0000

From [Livio comment in 2003](https://dillo-dev.auriga.wearlab.narkive.com/TYZWEMgE/how-to-use-dicache):

> Let me clarify a little bit about what the dicache is.
> 
> This is how Dillo works. When you ask for a URL (be it a root URL,
> like a HTML, or an image embedded in a page), it looks it up in a
> _memory_ cache. If it's already there it returns the content of the
> cache, and if not it makes a connection to retrieve that URL.
> 
> But there is a complication with respect to images. The images which
> are downloaded need to be decompressed to be displayed (that is,
> transformed from their original format, jpeg, gif, etc, to a bitmap
> format). So for images, first the dicache (_d_ecompressed _i_mage
> cache) is checked, then the cache, then finally it is retrieved from
> the site. The problem with dicache is that it eats up a *LOT* of
> memory, and the only benefit is the processing time of transforming
> from the original format to the bitmap. That's why the default is NO.

Good to know that dicache comes from "decompressed image cache".

I assume it is only worth it when we have multiple clones of the same pages
loaded with big images into multiple tabs, so we only need to decompress the
images once.

Other than that, it shouldn't retain any memory after the decompressed images
are evicted.
