Title: Handle link media in https://html.duckduckgo.com/html/
Author: rodarima
Created: Sun, 09 Jun 2024 10:40:08 +0000
State: open

When loading https://html.duckduckgo.com/html/, there is a <link> with a media tag which includes "all" in a comma separated value:

```html
<link rel="stylesheet" media="handheld, all" href="//duckduckgo.com/dist/h.a4820b3a129c734fee40.css" type="text/css"/>
```

Dillo doesn't seem to load the CSS style at all.

Here is the interesting part:

https://github.com/dillo-browser/dillo/blob/d8cc59e18d6bf90c91e5d9cf1f9c36587f4ab26c/src/html.cc#L1742-L1750


--%--
From: louis77
Date: Sat, 22 Jun 2024 00:11:38 +0000

I would expect Dillo to load the CSS when either "all" or "screen" is present in a list of media types. Btw. "handheld" is deprecated. However, I tried it with duckduckgo, the result is not encouraging :-).


--%--
From: rodarima
Date: Sat, 22 Jun 2024 08:34:23 +0000

Hi Louis,

> I would expect Dillo to load the CSS when either "all" or "screen" is 
> present in a list of media types.

Yeah, the current code only tries to find the substring "screen" or 
match the exact value "all". The relevant function is  
Html_tag_open_link not Html_tag_open_style (which also has the same 
problem).

> Btw. "handheld" is deprecated. However, I tried it with duckduckgo, 
> the result is not encouraging :-).

Yeah, I saw it. The lite version seems to be a bit better, but it 
doesn't appear centered with CSS:

https://lite.duckduckgo.com/lite/

Maybe we can defer this until we improve a bit the CSS support, so we 
don't make it worse that it currently is. The lite version is the 
default search engine, so we probably want that to make it work 
reasonably well.

The rule that seems to be moving the elements to the left is the 
text-align of the query input:

```css
.query {
	border-color:#dc5e47;
	border-style:solid solid solid solid;
	border-width:1px 1px 1px 1px;
	-moz-border-radius:3px;
	border-radius:3px;
	font-size:20px;
	padding:5px 6px;
  /*text-align:left;*/
	width:60%;
	max-width:600px;
	height:28px
}
```

It is aligning the input itself instead of the text inside it.
