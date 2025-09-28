Title: Support for CSS grid and flexbox
Author: rodarima
Created: Sun, 14 Jul 2024 12:02:05 +0000
State: open

CSS seems a clear improvement to [dillo 3.0.5-7](https://packages.debian.org/bookworm/dillo) but not yet good enough to handle https://gridbyexample.com/examples/page-layout/listing-with-thumbnails/ (most notably, the thumbnails are blown up to gigantic size: they get the width of the browser window).

I am trying to make https://oldalbum.bang.priv.no/ show something more interesting than "This page requires javascript" ([project described here](https://steinar.bang.priv.no/2022/02/12/1990-ies-picture-archives-in-modern-skin/))

I currently have something similar to the original https://www.bang.priv.no/sb/pics/ running but I was trying to style it up to look better but what I tried was maybe a bit advanced for dillo's current state.

Are there plans for CSS improvements? (should I remove the flexbox/grid formatting and try something simpler or is there radical improvements on the way for dillo?)

_Originally posted by @steinarb in https://github.com/dillo-browser/dillo/issues/216#issuecomment-2227000999_
            

--%--
From: rodarima
Date: Sun, 14 Jul 2024 12:16:53 +0000

> CSS seems a clear improvement to [dillo 3.0.5-7](https://packages.debian.org/bookworm/dillo) but not yet good enough to handle https://gridbyexample.com/examples/page-layout/listing-with-thumbnails/ (most notably, the thumbnails are blown up to gigantic size: they get the width of the browser window).

The CSS grid feature is not implemented in Dillo, so it get's ignored. What remains seems to follow what the CSS says for the wrapper:
```html
<div class="wrapper">
<h1>Responsive listing with thumbnails</h1>
        <ul class="imagegrid">
            <li><img src="/img/pattern-2-3.jpg" alt="Image at mobile view"></li>
            <li><img src="/img/pattern-2-1.jpg" alt="Image at wide view"></li>
            <li><img src="/img/pattern-2-2.jpg" alt="Image at medium view"></li>
        </ul>
```
```CSS
.wrapper {
  margin: 0 auto;
  width: 90%;
  max-width: 1600px; }
```

> I am trying to make https://oldalbum.bang.priv.no/ show something more interesting than "This page requires javascript" ([project described here](https://steinar.bang.priv.no/2022/02/12/1990-ies-picture-archives-in-modern-skin/))
> 
> I currently have something similar to the original https://www.bang.priv.no/sb/pics/ running but I was trying to style it up to look better but what I tried was maybe a bit advanced for dillo's current state.
> 
> Are there plans for CSS improvements? (should I remove the flexbox/grid formatting and try something simpler or is there radical improvements on the way for dillo?)

There are no plans. It would be good to support more advanced CSS features, but they won't happen any time soon (unless Dillo gets a surge in developers ready to focus on implementing new features).

Your website should fall back to something readable when you disable CSS, which Dillo would benefit from when features like the grid or flexbox are missing. See https://en.wikipedia.org/wiki/Progressive_enhancement

If you cannot provide that guarantee, you may want to use other approaches. Here is an example of Dillo gallery: https://dillo-browser.github.io/gallery/index.html

--%--
From: steinarb
Date: Sun, 14 Jul 2024 13:21:18 +0000

On a CSS side note: is there a way to make dillo re-read CSS files without stopping and starting dillo?

 (stopping and starting dillo is the only way I've found for reloading CSS so far)

--%--
From: rodarima
Date: Sun, 14 Jul 2024 13:45:06 +0000

> On a CSS side note: is there a way to make dillo re-read CSS files without stopping and starting dillo?
> 
> (stopping and starting dillo is the only way I've found for reloading CSS so far)

Try opening the remote CSS file in another tab and reloading it to refresh the cache, then reloading the HTML page that uses it (I haven't tested this, but it should work).

--%--
From: steinarb
Date: Sun, 14 Jul 2024 13:53:59 +0000

> Try opening the remote CSS file in another tab and reloading it to refresh the cache, then reloading the HTML page that uses it (I haven't tested this, but it should work).

Thanks! Loading oldalbum.css in a different pane, and reloading that pane worked. New CSS changes were picked up.



--%--
From: Mechtilde
Date: Mon, 05 Aug 2024 04:36:38 +0000

Hello,
please slow down. 
First the package will be removed from testing because the build failed with gcc-14.

You can create a bugreport against dillo and provide your help.
You can start to learn to build a proper Debian package, esp with git-buildpackage and the other used tools.
For this you can start at mentors.debian.net ad follow that description.

I saw your MR at salsa.debian.org. It doesn't build. So it can't be accepted.

For more information please ask.


--%--
From: Mechtilde
Date: Mon, 05 Aug 2024 04:39:42 +0000

sorry my comment was for issue 230