Title: Consider support for CSS used by Hugo PaperMod theme
Author: dslgr
Created: Tue, 04 Feb 2025 01:03:01 +0000
State: closed

It looks like Hugo PaperMod uses some CSS that isn't supported by Dillo. The blog entry links on the homepage aren't working. It maybe particularly good to support as it is the most popular [hugo theme by github stars](https://github.com/topics/hugo-theme).

https://adityatelange.github.io/hugo-PaperMod/

--%--
From: rodarima
Date: Tue, 04 Feb 2025 18:15:42 +0000

Fix your theme so it works without JS or CSS, this is awful:

```
<a class="entry-link"
  aria-label="post link to Install / Update PaperMod"
  href="https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-installation/">
</a>
```

The `a` tag should contain the whole entry, not be empty.

Improving Dillo CSS support is already planned.