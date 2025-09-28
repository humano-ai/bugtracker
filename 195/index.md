Title: Add support for relative reference URLs
Author: rodarima
Created: Tue, 11 Jun 2024 20:49:05 +0000
State: closed

Example in duckduckgo:

```html
<link rel="stylesheet" media="handheld, all" href="//duckduckgo.com/dist/lr.7ea0bec6b92cbc81590a.css" type="text/css"/>
```

Should load the stylesheet using the same scheme as the current page. See https://www.rfc-editor.org/rfc/rfc3986#section-4.2

--%--
From: rodarima
Date: Tue, 11 Jun 2024 20:51:40 +0000

Also: https://stackoverflow.com/a/4832046

> I could only find one that did not handle the protocol relative URL correctly: _an obscure *nix browser called Dillo_.

--%--
From: louis77
Date: Fri, 21 Jun 2024 23:13:48 +0000

Dillo resolves protocol-relative URLs, I've prepared an example here:
https://faq.emacs.ch/test.html

The reason that Dillo doesn't load the duckduckgo.com css above is, that Dillo does't like the media type is "handheld, all" as references in #189 .

Can you verify this?

--%--
From: rodarima
Date: Sat, 22 Jun 2024 08:42:33 +0000

Hi,

> @rodarima Dillo resolves protocol-relative URLs, I've prepared an 
> example here:
> https://faq.emacs.ch/test.html
> 
> The reason that Dillo doesn't load the duckduckgo.com css above is, 
> that the media type is "handheld". Dillo only loads media type 
> "screen".
> 
> Can you verify this?

Yeah it works fine, not sure how I came to that conclusion without 
testing it first :-)

Thanks for the test, we can close this now.
