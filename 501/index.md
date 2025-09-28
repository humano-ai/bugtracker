Title: Indentation error on cgit diff
Author: Rodrigo Arias Mallo
Created: Sun, 28 Sep 2025 14:44:28 +0200
State: open

Indentation with tabs in cgit diff seems to be broken, elements don't get
aligned as expected.

Here is one [example][1] for cgit which shows:

[1]: https://git.dillo-browser.org/dillo/commit/?id=1d55cf26a355b89a007e4a9bf7361d8a5c2c64cd

```
  render/form-display-none.html \
         render/github-infinite-loop.html \
      render/hackernews.html \
+       render/hr.html \
        render/img-aspect-ratio-absolute.html \
         render/img-aspect-ratio-div.html \
      render/img-aspect-ratio-mix-border.html \
```

Here is an inline reproducer:

<section style="font-family: monospace; white-space: pre;">
<div>@@ -18,6 +18,7 @@ TESTS = \</div><div> 	render/form-display-none.html \</div><div> 	render/github-infinite-loop.html \</div><div> 	render/hackernews.html \</div><div>+	render/hr.html \</div><div> 	render/img-aspect-ratio-absolute.html \</div><div> 	render/img-aspect-ratio-div.html \</div><div> 	render/img-aspect-ratio-mix-border.html \</div></section>

It seems to be caused by the whole diff being in **one line**, as if I split the
div elements into separate lines it works fine (but adds extra empty lines).

<section style="font-family: monospace; white-space: pre;">
<div>@@ -18,6 +18,7 @@ TESTS = \</div>
<div> 	render/form-display-none.html \</div>
<div> 	render/github-infinite-loop.html \</div>
<div> 	render/hackernews.html \</div>
<div>+	render/hr.html \</div>
<div> 	render/img-aspect-ratio-absolute.html \</div>
<div> 	render/img-aspect-ratio-div.html \</div>
<div> 	render/img-aspect-ratio-mix-border.html \</div>
</section>
