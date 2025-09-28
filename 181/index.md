Title: Custom CSS overrides per page
Author: rodarima
Created: Sat, 01 Jun 2024 22:09:08 +0000
State: open

The [dillo-plus](https://github.com/crossbowerbt/dillo-plus?tab=readme-ov-file#reader-mode-css-style) fork has implemented a reader mode allows pages to optionally load custom CSS styles without any remote or embeded CSS rules.

Currently we only allow loading a single style.css file that is always loaded.

I've been playing a bit with the current implementation of user CSS in `~/.dillo/style.css` and I observe that a single CSS file (or two with the reader mode) won't be able to solve some of the problems I see.

For example, in Hacker News, as they use tables to layout the content, and the tables have an implicit rule that restores the font size, we need special rules to make the text more legible for tables. However, those rules don't work well with tables in Wikipedia pages.

Another example is the long list of navigation links that some pages put in the top, that can be hidden or make smaller by clever CSS rules, but those need to be made per page to prevent them from hiding content where they shouldn't.

Ideally, we should be able to define per-page CSS rule. I was thinking if we could invent a `@media` syntax that could match a regex against the current page (and it only works in local override CSS files):

```CSS
@media (host: "*.reddit.com|*.wikipedia.com") {
  /* Rules for reddit and wikipedia */
}

@import url("./reddit.css") only (host: "*.reddit.com");
```

Ideally, those rules should live in a repository on their own, so they can be maintaned by a community.

--%--
From: rodarima
Date: Sat, 01 Jun 2024 22:16:32 +0000

Here is an example from Greasemonkey extension to make Wikipedia automatically switch to dark mode:

https://openuserjs.org/scripts/navchandar/Wikipedia_Auto_Dark_Mode/source

We probably can reuse most of those.

--%--
From: rodarima
Date: Sun, 02 Jun 2024 17:53:12 +0000

Another example by the Stylish extension that uses `@-moz-document`:

https://github.com/UserStyles/hacker-news-solarized-dark/blob/master/user-style.css
```CSS
@-moz-document domain("news.ycombinator.com") {
  /* ... */
}
```

See also: https://developer.mozilla.org/en-US/docs/Web/CSS/@document