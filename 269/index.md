Title: Improve default style readability
Author: rodarima
Created: Sun, 06 Oct 2024 10:42:32 +0000
State: open

Until `margin:auto` is supported, we have a lot of pages showing text glued to the Dillo window. Disabling CSS styles cause the default body margin of 5px to take effect. This margin is too small for computer screens, which is the default target.

It can be overrided by user styles `~/.dillo/style.css`, but we should select a reasonable default.

Here is an example where this happens: https://washbear.neocities.org/browsers

And this is how it looks with CSS disabled and the margin increased to 2.5em:

![margin](https://github.com/user-attachments/assets/cd0dcae5-271c-484e-bec4-f2cbe2680176)

Similarly, we may want to increase the default font size and the line height.

Here is the recommended style for HTML4 CSS2: https://drafts.csswg.org/css2/#html-stylesheet

Also: https://html.spec.whatwg.org/multipage/rendering.html

--%--
From: rodarima
Date: Sun, 06 Oct 2024 10:56:21 +0000

Hmm, I see that increasing the default margin breaks too many websites. Probably it is only okay to make it 8 or 10 px.

--%--
From: rodarima
Date: Sun, 06 Oct 2024 11:06:03 +0000

The default background color #dcd1ba is also too dark by default. The idea that we should not use too bright colors is good, but I don't think it should be addressed at the browser level by default, as there are tools that dimm bright colors on the whole system.

The spec recommend the canvas to be white by default, so I think it would be expected to switch it. Of course users can choose any other value in the config.