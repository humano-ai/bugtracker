Title: Add primitive SVG support
Author: rodarima
Created: Sun, 30 Jun 2024 15:13:13 +0000
State: closed

Adds primitive SVG suport by using a modified nanosvg library that can render Wikipedia equations. Many other features of the SVG standard are not implemented.

The idea is to provide a self-contained small implementation for SVG which can later be optionally replaced by a more complete implementation.

The initial version was taken from the mobilized fork: https://www.toomanyatoms.com/software/mobilized_dillo.html

Increases the floppy occupation from 87% to 89%.

--%--
From: rodarima
Date: Sun, 07 Jul 2024 09:29:28 +0000

Cannot render equations that use `<symbol>`: https://mathworld.wolfram.com/images/equations/FourierTransform/NumberedEquation10.svg

--%--
From: rodarima
Date: Sun, 07 Jul 2024 19:09:43 +0000

Added primitive support for symbols too.

--%--
From: rodarima
Date: Sun, 14 Jul 2024 15:16:57 +0000

PEC badges in SVG are broken too: https://dillo-browser.github.io/pec/

--%--
From: rodarima
Date: Sun, 14 Jul 2024 15:34:44 +0000

> PEC badges in SVG are broken too: https://dillo-browser.github.io/pec/

This can be "solved" by converting the SVG to paths, which is enough for now.