Title: Presentations with Dillo in plain HTML
Author: rodarima
Created: Wed, 08 May 2024 21:19:28 +0000
State: open

It would be nice if we can use Dillo to show slides too (specially if the presentation is about Dillo itself).

One option could be to design the HTML document in such a way that has pages of the viewport size, and then an anchor link to the next element. This would involve some kind of automatic tool to inject the HTML links, so the document must be prepared to be presented.

Another, maybe simpler, solution is to simply rely on header sections h1, h2... as the delimiters of a page, which is also set to the viewport size. Then we just need to automatically add a virtual anchor to each section and a keymap to jump to the next/previous section of the same level. This will also allow multiple levels, so we can go up, then skip a few parts and go down again. Ideally, a markdown document could be converted to HTML and directly rendered in Dillo as slides.

This may also open the door to read Ebooks or other documents by well delimited pages. Avoiding the scroll can lead to significant power save, as we only need to render once per page instead of once per mouse wheel step.

Manually adding anchors to specific sections doesn't require any special machinery.

--%--
From: rodarima
Date: Tue, 01 Oct 2024 19:04:52 +0000

I've have implemented a proof of concept, which jumps to the next fragment of the page. This is probably the most portable way to do it, as we can link to a given slide from any browser.

However, it requires users to write HTML with id tags, which it is a bit cumbersome to do by hand.

The implementation adds two new keys for next and previous fragment, but it doesn't take into account the current position of the viewport.

There is a problem with the layout engine an the 100% height, which makes creating slides almost impossible, as they need to know the size of the Dillo window. The idea is to be able to adjust the size as the user needs, in contrast with PDF slides.

--%--
From: rodarima
Date: Tue, 01 Oct 2024 21:13:48 +0000

The slides problem can be solved by implemented the vh and vw units, which should be easy to do.

--%--
From: rodarima
Date: Sat, 05 Oct 2024 07:53:19 +0000

We don't really need any extra machinery to jump from one slide to the next if we can define elements to occupy exactly one slide. The only change we need is for prev/next page to really move one whole page.

We may just add a toggle to remove the margin when advancing pages. Maybe we can also transform the navigation into whole pages only, so the scroll bar and scroll wheel navigate full slides. This will make it possible to quickly jump to a given slide.

Slides must keep the content inside the slide page, otherwise we risk shifting all pages.

--%--
From: rodarima
Date: Sun, 12 Jan 2025 13:49:33 +0000

Making it screen based is risky, as any overflow will cause next slides to misalign. Making it fragment based is self correcting and allows slides larger than the screen. This plays good with multiple zoom levels.

Let's not rush this on 3.2.0 and leave it for a future release.