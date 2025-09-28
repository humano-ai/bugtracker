Title: Scaling for hidpi/4k screens
Author: Munchotaur
Created: Tue, 14 May 2024 17:06:24 +0000
State: open

I just installed 3.1.0 and it's great but for the scaling on my 4k work monitor. Is there a make option to set a different scale for Dillo?

--%--
From: rodarima
Date: Tue, 14 May 2024 17:17:21 +0000

We don't really have support for DPI yet.

As a workaround, you can use the [`font_factor` option](https://github.com/dillo-browser/dillo/blob/b0f558ce519107a37f0b7cfd5a5a4f6b3d4ae64b/dillorc#L74) and can put arbitrary [CSS in ~/.dillo/style.css](https://dillo-browser.github.io/user_help.html#style-css) to increase the font size like this:

```css
body {
  font-size: 20px !important;
}
```

There is also a work in progress for zoom, see PR #156.

--%--
From: Munchotaur
Date: Tue, 14 May 2024 17:27:12 +0000

Thanks. At least that should sort out the page itself -- I guess the UI is a whole other can of worms?

--%--
From: rodarima
Date: Tue, 14 May 2024 18:58:56 +0000

> I guess the UI is a whole other can of worms?

FLTK 1.4 should [support DPI out of the box](https://www.fltk.org/doc-1.4/group__fl__screen.html#gab1f3def038ace55315391d484be2d294), but AFAIK, FLTK 1.3 doesn't support it (didn't test). Not sure how long it will take to have the [release ready](https://github.com/fltk/fltk/milestone/1), but hopefully not too long.

But if you want to explore other options in the meanwhile feel free to do so :-)

--%--
From: Munchotaur
Date: Tue, 14 May 2024 19:22:46 +0000

I'll see what I can see! However that note on FLTK 1.4 sounds promising so here's looking forward to the next release.