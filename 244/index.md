Title: Bad background for cached image with transparency
Author: rodarima
Created: Wed, 14 Aug 2024 12:30:27 +0000
State: open

When two or more copies of the same image with transparency appear in a single
document, the transparent pixels are mixed with the background of the first
image container. However, subsequent images take the image buffer from the cache
inheriting the same background, regardless of the background where the rest of
images are placed.

The cache should not be used if the background is different.
