Title: Detect RSS on a page and make it visible
Author: rodarima
Created: Sun, 14 Jan 2024 15:39:52 +0000
State: open

From https://alpha.polymaths.social/@amin/statuses/01HH6G3MX196P4AWMT7CA7SB2R

> A neat thing about lynx I've noticed is that it makes the link to the RSS feed (which I mentioned the syntax for to you earlier) visible, as "[#RSS](https://fosstodon.org/tags/RSS)", the first thing on the page. I rather like that. Wish browsers were better about integrating feed-related features.

We may be able to integrate such feature by adding a plugin that rewrites the head link tag into something visible in the body. The links have this look:
```html
<link rel="alternate" type="application/rss+xml" href="/feed.xml" />
```

Would require to have #56 working.

--%--
From: benjaminbhollon
Date: Sun, 14 Jan 2024 16:55:47 +0000

A note; looks like lynx uses the `title` attribute of these links as the link text. I have multiple feeds on https://benjaminhollon.com, for example, with different titles, and it uses the titles I set. :)

--%--
From: rodarima
Date: Sun, 14 Jan 2024 17:12:43 +0000

Thanks, I leave here a picture of lynx for reference:

![rss](https://github.com/dillo-browser/dillo/assets/3866127/b040d54e-ad34-4416-9419-4f6b915397a5)

With the following link tags:

```html
<link rel="alternate" type="application/atom+xml" title="Musings Blog Atom Feed" href="https://benjaminhollon.com/musings/feed/">
<link rel="alternate" type="application/atom+xml" title="Aggregrated Atom Feeds" href="https://benjaminhollon.com/feed/?from=musings%2Ctty1%2Cpoetry%2Cblurbs">
<link rel="alternate" hreflang="en" href="http://localhost/">
```

This should be doable with a small plugin that rewrites the HTML, parsing the link tags and injects them in the body with the proper title and hyperlinks. We still need to work in the infrastructure to make rewriting HTML easier.

--%--
From: benjaminbhollon
Date: Mon, 15 Jan 2024 02:44:53 +0000

Huh, that last alternate link is odd. Not sure why it's there.

I'll check my site's code. Wasn't expecting to find an issue via this issue. XD

Edit: looks like it's from my SSG's multilanguage plugin, but with the root domain messed up. (Also not sure why it's adding it with the current page language.)

Might be worth excluding rel="alternate" links that have the `hreflang` attribute, or displaying them differently, since those are links to alternate translations of the page.

--%--
From: rodarima
Date: Sat, 27 Jan 2024 10:57:01 +0000

> I'll check my site's code. Wasn't expecting to find an issue via this issue. XD

Sometimes it happens :-)

> Might be worth excluding rel="alternate" links that have the hreflang attribute, or displaying them differently, since those are links to alternate translations of the page.

Yeah, probably we should first only focus on `application/atom+xml` and exclude everything else. In Dillo there is already a [hack to inject a table at the beginning of a page](https://github.com/dillo-browser/dillo/blob/master/src/html.cc#L3104-L3110) to "support" the meta refresh tag, but I want to use this as an example to make the design of plugins that can do those tasks, instead of making more hacks.