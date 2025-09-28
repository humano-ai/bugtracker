Title: Add WebP image support
Author: rodarima
Created: Sun, 24 Nov 2024 18:19:13 +0000
State: closed

Adds WebP image support, enabled by default if libwebp is present at configure time.

Fixes: https://github.com/dillo-browser/dillo/issues/71
See: https://www.toomanyatoms.com/software/mobilized_dillo.html

--%--
From: ghost
Date: Mon, 25 Nov 2024 10:45:43 +0000

I'm not a fan of having this in Dillo and agree with many of the points linked in this comment:
https://github.com/dillo-browser/dillo/issues/71#issuecomment-2180178620

If you are intent on commiting this, can we at least have an option to disable this at runtime for the people who don't build Dillo from source?

--%--
From: rodarima
Date: Tue, 26 Nov 2024 20:05:25 +0000

> I'm not a fan of having this in Dillo and agree with many of the points linked in this comment: [#71 (comment)](https://github.com/dillo-browser/dillo/issues/71#issuecomment-2180178620)

Out of curiosity, can you elaborate on what is your worry on using libwebp for decoding WebP images (with respect to the other decoders)?

I think whether WebP leads to a better compression ratio and thus should be used widely is out of the scope of this PR, as we are only focusing on "given a page with WebP images what do we do?".

> If you are intent on commiting this, can we at least have an option to disable this at runtime for the people who don't build Dillo from source?

We have the `load_images` switch, but we could add another option that allows you to select a subset of formats to never load.

However, I would expect any user that worries about which decoders are being used, to be able to build Dillo from source, selecting whichever subset of image support at build time.

--%--
From: ghost
Date: Tue, 26 Nov 2024 22:14:07 +0000

> Out of curiosity, can you elaborate on what is your worry on using libwebp for decoding WebP images (with respect to the other decoders)?

I don't believe that Dillo should rush to endorse a new Google image format which doesn't provide a clear benefit over the existing well-tested formats, and which also faces security questions following a recent exploit. Unfortunately a few sites still insist on using WebP, but I think it's something to be rejected, not embraced.

> We have the `load_images` switch, but we could add another option that allows you to select a subset of formats to never load.

Firefox and Chrome both have the ability to disable WebP at runtime, so I think Dillo should too.



--%--
From: rodarima
Date: Tue, 26 Nov 2024 23:58:08 +0000

> I don't believe that Dillo should rush to endorse a new Google image format which doesn't provide a clear benefit over the existing well-tested formats, and which also faces security questions following a recent exploit. Unfortunately a few sites still insist on using WebP, but I think it's something to be rejected, not embraced.

I don't have any interest in endorsing a Google format, I think the current JPEG and PNG are mostly okay. But that doesn't change the fact that websites are increasingly using WebP.

Here is an example of usage from https://w3techs.com/technologies/history_overview/image_format/all/y:

![image](https://github.com/user-attachments/assets/d4b6da0b-c0a8-4a39-a3c3-8ecf4d9ca99c)

Here is the methodology: https://w3techs.com/technologies

Another study from 2023: https://arxiv.org/pdf/2310.00788

If you want to change this trend, I don't think avoiding WebP support on Dillo will have any measurable impact. I would probably be better to convince web developers that it is not a good idea to use it.

> also faces security questions following a recent exploit

I have not studied that exploit or the quality of the code it affects to be able to make predictions for future RCEs. But keep in mind that the other image libraries are not free from CVEs:

https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=libpng
https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=libjpeg
https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=libwebp

Same for the custom GIF and nanosvg decoders. These are not widely used, so it is likely that there is no interest in finding exploits for them. It doesn't mean they don't have RCE bugs. I would be a good idea to fuzz them.

> Firefox and Chrome both have the ability to disable WebP at runtime, so I think Dillo should too.

I don't think it is a bad idea to be able to disable them at runtime, it is probably an easy patch.

--%--
From: ghost
Date: Wed, 27 Nov 2024 10:30:08 +0000

> I don't have any interest in endorsing a Google format, I think the current JPEG and PNG are mostly okay. But that doesn't change the fact that websites are increasingly using WebP.
> 
> Here is an example of usage from https://w3techs.com/technologies/history_overview/image_format/all/y:

According to your links, WebP still has under 15% usage on the web. Out of that, I wonder how many of those sites even work on Dillo to begin with.

There is also some concern about the future of the format, since the US is considering forcing the sale of Chrome (and WebP) to a potentially even more hostile corporation.

> If you want to change this trend, I don't think avoiding WebP support on Dillo will have any measurable impact. I would probably be better to convince web developers that it is not a good idea to use it.

It's perfectly reasonable to take a principled stand, while knowing full well you're not going to change the world. I don't think we are in a position to convince web developers of anything.

> I don't think it is a bad idea to be able to disable them at runtime, it is probably an easy patch.

Great, this would be the best compromise.

--%--
From: rodarima
Date: Wed, 27 Nov 2024 19:32:22 +0000

> It's perfectly reasonable to take a principled stand, while knowing full well you're not going to change the world.

Dillo is a tool to render the Web (or at least a useful subset) in older/smaller computers. If you want to avoid using WebP, nobody is forcing you to use it, you can build Dillo with `--disable-webp` (or in the future via the config file).

Refusing to implement support for WebP means that users that cannot use Firefox/Chrome due to computing constraints (like me sometimes) are left with not many choices (if at all) to load pages with WebP images.

This may be a reasonable option to you, but may not be for everyone. That's why I prefer to give the users the choice to decide what they want.

> Great, this would be the best compromise.

Let's address this in another PR.

I'll merge this if there are no more concerns.