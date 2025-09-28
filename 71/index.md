Title: Add support for WebP images
Author: rodarima
Created: Fri, 02 Feb 2024 22:33:33 +0000
State: closed

Similarly as for SVG images, support for WebP images would be nice.

Libraries from #53:
- https://chromium.googlesource.com/webm/libwebp

The test procedure is simple as we only need to generate a pair of images like PNG and WebP, and ensure the rendering is the same for both.

--%--
From: MrMinderbinder
Date: Thu, 20 Jun 2024 09:01:40 +0000

SVG support sounds good, WebP not so much...

https://siipo.la/blog/is-webp-really-better-than-jpeg
https://eng.aurelienpierre.com/2021/10/webp-is-so-great-except-its-not/
https://www.jwz.org/blog/2023/09/webp-is-going-great/

--%--
From: JessFairbairn
Date: Tue, 23 Jul 2024 13:01:27 +0000

Probably a separate bug but if and when webp or SVG support is added it would be worth adding support for the `<picture>` tag (assuming it isn't already)