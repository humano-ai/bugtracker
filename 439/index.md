Title: Roadmap for FLTK 1.4
Author: rodarima
Created: Sun, 31 Aug 2025 22:29:08 +0000
State: open

## Roadmap for FLTK 1.4

As there are several problems porting Dillo to FLTK 1.4, in order to prevent
blocking the next release for a very long time, we will decompose the issues in
stages.

<blockquote style="background-color:yellow; padding: 1em; border: solid 1px black">

**IMPORTANT NOTICE:** Until all these stages are completed, Dillo will NOT have
official FLTK&nbsp;>=&nbsp;1.4 support. If you maintain a Dillo package, please
keep Dillo built with FLTK 1.3 for the general public.

Even if it looks fine to you, users with different screen DPIs will suffer
severe graphical glitches. That's why is kept as an **experimental** feature and
disabled by default.

</blockquote>

### Stage 1: Build support for FLTK >= 1.4 (DONE)

We need to be able to successfully build with newer FLTK versions as well as
retain compatibility with FLTK 1.3 and prior.

This is now possible with the `--enable-experimental-fltk`
[configure flag](
https://git.dillo-browser.org/dillo/commit/?id=227366655bb1e3514d00381b01e3132bf4770651).

Related issues:

- [509: Experimental build with FLTK 1.4.X](/509)

### Stage 2: Stable 96 DPI support (MOSTLY DONE)

Make sure that we can render PIXEL PERFECT pages when compared with FLTK 1.3
using both Xft and Pango+Cairo backends. We can perform image differences with
renders from Chromium, Firefox and other tools that we use as reference.
We should also test Dillo with multiple graphics implementations (Xorg and
Wayland). This is to make sure that we don't introduce regressions on systems
that will switch to FLTK 1.4.

The big problem with blurry text in Pango is now solved and we achieve almost
perfect rendering when comparing Xft and Pango (notably, Pango has kerning
support, so it won't match Xft exactly).

We can unblock the [3.3.0 release](/510/) once this stage done.

Related issues:

- [410: Test font rendering in FLTK 1.4.4 with Xft backend](/440/)
- [518: Blurry FLTK 1.4 fonts](/518)

### Stage 3: Support for integer multiples of 96 DPI

We need to scale the icons and probably other issues regarding the difference of
scale. For this we need to test with an artificial scale as I don't have a 192
DPI screen.

This probably won't exhibit scrolling glitches.

### Stage 4: Support for fractional multiples of 96 DPI

We need to keep in mind that FLTK [will "snap"](
https://github.com/fltk/fltk/commit/2430cb1f4280a8dd58bb6ad8a6099c223f4e6004.patch)
the DPI for values close to 96 back to exactly 96. We need to perform tests with
DPIs higher than that (or patch FLTK to avoid the snapping) in order to exhibit
problems. It will likely cause bad redrawing issues on the main scroll and we
need to see how to solve it without introducing a huge computational penalty
(avoiding full redraw).

Another problem is how values close to 96 (or multiples) affect hinting, as I
suspect fonts are only manually hinted to specific sizes.

This stage is probably going to be *really hard* to make it right.

Related issues:

- [309: FLTK 1.4.0 problems with pixel units](/309)

## Notes

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

Another issue that I see is that it doesn't seem to be possible to query FLTK on
which backend or which rendering engine is using. For example, Xft and Pango
have different rules on how a font is matched depending on its name.

Also, we may need to restrict which versions of FLTK 1.4 are allowed, as some
issues may only be fixed in later releases.
