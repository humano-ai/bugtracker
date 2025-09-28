Title: Change font size with Control +/-
Author: rodarima
Created: Wed, 20 Dec 2023 00:01:43 +0000
State: closed

The default font size factor in Dillo is fixed until the browser is closed and open again. However, some pages have very small font sizes and it would be convenient if we can allow the factor to be modified live.

The shortcuts <kbd>Control</kbd><kbd>+</kbd> and <kbd>Control</kbd><kbd>-</kbd> are typically used for this end in other browsers.

--%--
From: ToyKeeper
Date: Wed, 03 Jan 2024 21:46:32 +0000

Another effective solution for this: Dillo-plus has a book reader mode, which is basically just another stylesheet which can be added or removed on the fly.  When a site isn't readable with default settings, I find it usually looks good after I disable remote and inline CSS and enable book reader mode instead.

It would be cool if there were hotkeys to do this, or ideally, the ability to define multiple different stylesheets and switch between them with hotkeys.  Then the user could change anything they want, not just limited to the font size.

As another stretch goal, so to speak, it'd be awesome if user stylesheets could be enabled automatically if the URL prefix matches... like, if the URL starts with a particular string, then enable a particular stylesheet.  That way, they could permanently override things per site.

If someone feels especially ambitious, there could even be a repository of site-specific or platform-specific overrides, to make popular sites work better in Dillo.  For example, I use a stylesheet to fix the layout of Discourse forums.  I've been meaning to do one for Github too.  Something like this could be done in a DPI, perhaps.

At minimum though, it'd be helpful to have hotkeys to toggle remote and inline CSS and reader mode CSS.


--%--
From: rodarima
Date: Wed, 03 Jan 2024 22:02:35 +0000

> Another effective solution for this: Dillo-plus has a book reader mode, which is basically just another stylesheet which can be added or removed on the fly. When a site isn't readable with default settings, I find it usually looks good after I disable remote and inline CSS and enable book reader mode instead.

Nice to know, I haven't tested much dillo-plus. However I would like to still have a way to increase *everything* on the page easily and temporarily, including images. Specially for users that are not familiar with CSS (or they are too lazy to write it, like me when is late at night).

I have a patch that works kind of okay, but there are some problems to fix still.

> 
> It would be cool if there were hotkeys to do this, or ideally, the ability to define multiple different stylesheets and switch between them with hotkeys. Then the user could change anything they want, not just limited to the font size.
> 
> As another stretch goal, so to speak, it'd be awesome if user stylesheets could be enabled automatically if the URL prefix matches... like, if the URL starts with a particular string, then enable a particular stylesheet. That way, they could permanently override things per site.

I had some idea to do this already, and also to run some filter script too, in case you need to also patch the HTML of certain sites. Regarding switching styles I also wanted to include a dark/light theme (at least) so you can switch colors for surfing the web at night (much like Dark Reader). But one step at a time :-)

> If someone feels especially ambitious, there could even be a repository of site-specific or platform-specific overrides, to make popular sites work better in Dillo. For example, I use a stylesheet to fix the layout of Discourse forums. I've been meaning to do one for Github too. Something like this could be done in a DPI, perhaps.

I'll be surprised if this is not a thing already. I know for example Firefox has some quirks to fix some websites, but is built in the browser.