Title: Fix blockquote and dd having textblocks double added
Author: campaul
Created: Thu, 29 May 2025 22:34:59 +0000
State: open

Test for #404

--%--
From: campaul
Date: Mon, 02 Jun 2025 18:01:43 +0000

The `Html_tag_open_blockquote` and `Html_tag_open_dd` were calling `Html_add_textblock`, essentially turning the elements into block elements despite them being inline. Following that, if a style was applied that would actually make the element be block (`display: block`, `display: inline-block`, or `float: left/right`), then it would end up having the textblock double added.

To fix this I removed both of those functions and replaced them with calls to `Html_tag_open_default`. I then added `blockquote` and `dd` to the list of elements that have `display: block` applied by default which is recommended by the CSS specification and what other browsers do.

--%--
From: rodarima
Date: Mon, 30 Jun 2025 20:41:03 +0000

Thanks, I was trying to find out why it was being done that way. I traced it back to the first commit we have recoded from 2007 which already used the textblock (my comments apply to dd too):

https://github.com/dillo-browser/dillo/blob/93715c46a99c96d6c866968312691ec9ab0f6a03/src/html.cc#L2770-L2774

https://github.com/dillo-browser/dillo/blob/93715c46a99c96d6c866968312691ec9ab0f6a03/src/html.cc#L639-L643

At that point there was no logic to handle display elements like we have now:

https://github.com/dillo-browser/dillo/blob/f6abc117030f372261cef98e191113a2078c8c1b/src/html.cc#L4094-L4119

I'm guessing this would only potentially cause problems if we have an inline blockquote? As before we would have a new textblock but now we won't.

Here is a testcase with inline blockquote:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Test inline blockquote</title>
    <style type="text/css">
      div {
        background-color: #ededed;
        margin: 10px 3em;
        padding: 15px;
        border-radius: 5px;
      }
      blockquote {
        display: inline;
        border: solid 2px black;
      }
    </style>
  </head>
  <body>
    <div>
      <blockquote cite="https://www.huxley.net/bnw/four.html">
        Words can be like X-rays, if you use them properly—they’ll go through
        anything. You read and you’re pierced.
      </blockquote>
      <p style="text-align:right">—Aldous Huxley, <cite>Brave New World</cite></p>
    </div>
  </body>
</html>

```

And here it how it changes the rendering from this branch, master and Firefox (top to bottom):

![bq](https://github.com/user-attachments/assets/16a51d56-a8b3-41aa-bc86-17833ae4cf24)

Not sure if there is a good way to avoid breaking the current behavior for inline. We don't follow the "correct" inline behavior either.

--%--
From: campaul
Date: Fri, 08 Aug 2025 02:54:46 +0000

> Not sure if there is a good way to avoid breaking the current behavior for inline. We don't follow the "correct" inline behavior either.

It looks like it wont be too hard to implement the correct border behavior for inline elements, so I'm going to focus on implementing that first then return to this PR after that's done.

--%--
From: rodarima
Date: Mon, 11 Aug 2025 11:37:07 +0000

> I'm going to focus on implementing that first then return to this PR after that's done.

I'll mark this as WIP in the meanwhile.