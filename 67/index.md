Title: CSS margin auto is not working
Author: rodarima
Created: Thu, 01 Feb 2024 17:59:02 +0000
State: open

The red div should appear in the center:

![image](https://github.com/dillo-browser/dillo/assets/3866127/d3872e12-b024-4cf6-a796-71fa1d355af6)

Tested with:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Test CSS margin auto</title>
    <style>
      div {height:100px}
      .container {width:300px; background: lightgreen}
      .child {width:100px; background: brown; margin:auto }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="child"></div>
    </div>
  </body>
</html>
```

This breaks a lot of pages that rely on this method to center content on the page.

--%--
From: campaul
Date: Thu, 10 Apr 2025 17:02:28 +0000

I'm interested in working on this if it's not already in progress. I put together a rough proof of concept to get an idea of what would be involved and collected my notes from the process below. Let me know if you'd like me to start working on this and if this sounds like a reasonable approach.

---

The relevant portion of the CSS spec for calculating widths and margins is https://www.w3.org/TR/CSS2/visudet.html#Computing_widths_and_margins. There are several different cases that have to be handled, but the main issue is that widths and margins are dependent on each other. In some cases margin is used to compute width, and in other cases width is used to compute margin. Unfortunately, the current dillo code assumes that margin is always an absolute value.

Some potential steps to make this work:
1) Convert `style->margin.left` and `style->margin.right` values to be Lengths
2) Remove `boxOffsetX`, `boxRestWidth`, and `boxDiffWidth`, from `style.hh`. Because calculating them sometimes requires knowing the width of the parent element, they can't actually be calculated using just the style.
3) Update `Widget::calcWidth`, `Widget::getAvailWidth`, and `Widget::getAvailWidthOfChild` to not make use of any of the functions listed in the last step and instead compute all of the margin and width values based on the rules in the linked spec. I would also expand `calcWidth` to take pointers for setting `marginLeft` and `marginRight`.
4) Update anything that accessed `style->margin.left`, `style->margin.right`, or any of the removed functions to instead use values computed by `calcWidth`.

---

Once this is issue is complete, similar work should be done for the corresponding height functions based on the heights and margins spec https://www.w3.org/TR/CSS2/visudet.html#Computing_heights_and_margins

--%--
From: rodarima
Date: Thu, 10 Apr 2025 17:54:21 +0000

> I'm interested in working on this if it's not already in progress. I put together a rough proof of concept to get an idea of what would be involved and collected my notes from the process below. Let me know if you'd like me to start working on this and if this sounds like a reasonable approach.

Thanks!, the renderer can use more help :)

> The relevant portion of the CSS spec for calculating widths and margins is https://www.w3.org/TR/CSS2/visudet.html#Computing_widths_and_margins. There are several different cases that have to be handled, but the main issue is that widths and margins are dependent on each other. In some cases margin is used to compute width, and in other cases width is used to compute margin. Unfortunately, the current dillo code assumes that margin is always an absolute value.
> 
> Some potential steps to make this work:
> 
>    1. Convert `style->margin.left` and `style->margin.right` values to be Lengths
> 
>    2. Remove `boxOffsetX`, `boxRestWidth`, and `boxDiffWidth`, from `style.hh`. Because calculating them sometimes requires knowing the width of the parent element, they can't actually be calculated using just the style.
> 
>    3. Update `Widget::calcWidth`, `Widget::getAvailWidth`, and `Widget::getAvailWidthOfChild` to not make use of any of the functions listed in the last step and instead compute all of the margin and width values based on the rules in the linked spec. I would also expand `calcWidth` to take pointers for setting `marginLeft` and `marginRight`.
> 
>    4. Update anything that accessed `style->margin.left`, `style->margin.right`, or any of the removed functions to instead use values computed by `calcWidth`.
> 

Sounds like a reasonable plan. I would recommend adding more tests, as I only added a very simple one, but we would need to handle multiple nested elements with relative margins and widths.

We would also need to keep an eye on any extra performance cost.

It would be convenient to extend the Doxygen documentation about the renderer in those parts that it are not well covered and to document how the new computation behaves. We also need to make sure that is clear what box is used to resolve the relative lengths.

> Once this is issue is complete, similar work should be done for the corresponding height functions based on the heights and margins spec https://www.w3.org/TR/CSS2/visudet.html#Computing_heights_and_margins

I recommend leaving this for another PR/issue.

