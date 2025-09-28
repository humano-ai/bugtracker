Title: AVIF/AV1 image support
Author: dflock
Created: Fri, 03 Jan 2025 17:32:49 +0000
State: closed

It would be great if dillo supported avif images. Here are some resources that might be useful when implementing:

- https://en.wikipedia.org/wiki/AVIF
- avif spec: https://aomediacodec.github.io/av1-avif/
- avif decode library: https://github.com/AOMediaCodec/libavif
  - other options for decoding:
  - https://github.com/strukturag/libheif
  - https://sail.software/
- Recent pr for adding webp support: https://github.com/dillo-browser/dillo/commit/b9e801cb940b45cfd9a4cf95bf5af68b084156b4

--%--
From: rodarima
Date: Mon, 06 Jan 2025 00:34:03 +0000

> It would be great if dillo supported avif images.

I don't think so, at least not yet. Every time we add support for a new image
decoder, we increase the surface for new attacks. [Here][1] you can see that
only 0.4% of set of sites use AVIF.

[1]:https://w3techs.com/technologies/overview/image_format

I'll wait until it is more widely adopted.

Notice that this has nothing to do of how good or bad is AVIF as an image
format.
