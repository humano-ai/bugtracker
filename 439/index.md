Title: Roadmap for FLTK 1.4
Author: rodarima
Created: Sun, 31 Aug 2025 22:29:08 +0000
State: open

**This is an internal issue so I can organize myself (do not comment here, open
another issue if you have a problem or suggestion).**

There are several problems we need to solve, and not sure if it would be a good
idea to wait until they are all solved before we integrate FLTK 1.4 support.

First, we need to test many combinations of FLTK build configurations. We need
at least support for X11, Wayland and Mac OS. Each backend can use cairo or not,
depending on which. And on top of that, there is Pango vs Xft, which cause
different font rendering issues.

Apart from the backend, there is the issue of the High DPI screens. There are
several problems that come from it. First, screens may report the wrong size so
it would be a good idea to have a calibration method, so we know 1 cm of CSS is
1 cm in the physical world. Apart from this, the screen may have been configured
wrongly (a 120 DPI display is configured as 96 DPI). Even if the screen is well
configured, if the DPI is slightly higher than 96 (less than 10%) it will be
clamped to 96 DPI by FLTK, which will cause issues when trying to render at a
particular scale.

One posible way forward is to release the support under an experimental flag, as
we continue to add support for more backends and more modes of DPIs. For now, I
think we can safely release X11 support with the Xft backend (no Cairo or Pango)
and exclusively 96 DPI screens. So far I can see that FLTK 1.4 with 96 DPI and
scale 1, using the Xft backend produces identical rendering results as FLTK
1.3.11, which is a good outcome.

Another issue that I see is that it doesn't seem to be possible to query FLTK on
which backend or which rendering engine is using. For example, Xft and Pango
have different rules on how a font is matched depending on its name.

Also, we may need to restrict which versions of FLTK 1.4 are allowed, as some
issues may only be fixed in later releases. We should support the latest release
1.4.4.
