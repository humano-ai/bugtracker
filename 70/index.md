Title: Add support for SVG images
Author: rodarima
Created: Fri, 02 Feb 2024 22:30:44 +0000
State: closed

Add support for SVG images, as they are becoming more frequent in the web.

We probably should link or embed a SVG library that performs the rastering, but make it optional so it can be disabled on build time.

Some options from #53 :

- https://git.netsurf-browser.org/libsvgtiny.git/tree/README
- https://github.com/fltk/nanosvg (already in FLTK)
- https://github.com/RazrFalcon/resvg

In other to test that it works fine, we could have a reference page with a image already rendered to PNG or a similar format, and compare the result with the new library rendering the same SVG image.

--%--
From: rodarima
Date: Sun, 12 May 2024 20:49:09 +0000

One of the main good uses of SVG images is to read Wikipedia equations, which are included as a fallback for non-JS browsers. The equations are all rendered with MathJax, which defines all the glyphs using `<defs>` and then places each glyph in the proper position using the `<use>` tag.

This is problematic, as both libsvgtiny and nanosvg lack support for them and cannot render Wikipedia equations. I tested librsvg and renders properly those equations, but is by far a very large and complex library:

![fractal](https://github.com/dillo-browser/dillo/assets/3866127/7d35e789-898a-4189-a58a-3f152caafb5d)

![maxwell](https://github.com/dillo-browser/dillo/assets/3866127/81a1bb19-8e94-45a5-8ce8-1fc0dbaee9e3)

![maxwell2](https://github.com/dillo-browser/dillo/assets/3866127/f24de452-f6b5-4607-9c4a-190200deee57)


(We also need to avoid rendering the MathML parts of the Wikipedia)

Ideally we should either implement support for defs/use or find another less complicated library that implements it. The size of librsvg is a wopping 3MiB, without dependencies.

--%--
From: rodarima
Date: Sat, 06 Jul 2024 12:33:13 +0000

Nanosvg doesn't support text or tspan tags either.

--%--
From: rodarima
Date: Sat, 27 Jul 2024 11:17:50 +0000

Basic support for SVG added in https://github.com/dillo-browser/dillo/pull/211

This is enough to render Wikipedia equations, but it lacks a lot of other SVG features that should be handled by a more elaborate SVG library. The benefit of using nanosvg is that it is builtin into Dillo without dependencies.

In the future we may want to add an support for other libraries, so that they can be enabled at configure time.