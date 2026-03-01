Title: Blurry FLTK 1.4 fonts
Author: Rodrigo Arias Mallo
Created: Sun, 22 Feb 2026 22:40:08 +0100
State: closed

Compared with FLTK 1.3 I see that in FLTK 1.4.4 and FLTK from git fonts look
more blurry.

I suspect this has to do with how the hinting and antialiasing is being done as
well as the sub-pixel placement of each glyph.

See <https://en.wikipedia.org/wiki/Font_hinting>

For Xorg, FLTK 1.3 seems to take the font configuration from .Xresources (I can
alter the hinting this way). I can reproduce the same blurry problems with the
`font` FLTK test if I open the same font "Dejavu Sans (book)".

--%--
From: Rodrigo Arias Mallo
Date: Sun, 01 Mar 2026 19:06:09 +0100

FLTK issue: <https://github.com/fltk/fltk/issues/1365>

After careful observation, this problem is not caused by a misconfiguration of
hinting or antialiasing. The problem is that the rendering of the text is placed
with a half pixel misalignment, which causes the edge of the characters to
become blurry.

The problem is only present when using the Pango/Cairo rendering backend,
switching to Xft avoids it.

This is a FLTK bug and has been fixed in:

- FLTK 1.5 branch <https://github.com/fltk/fltk/commit/486da9376d5e32a9bff2bf5446d0bd0e0db7cb20>
- FLTK 1.4 branch <https://github.com/fltk/fltk/commit/17b30b55e39418b6a56c047f896df7f86ba4189d>

It is planned to be released in the FLTK 1.4.5 release, so we don't need to do
anything additional on Dillo. Affected versions 1.4.0 to 1.4.4 with the Pango
backend will render blurry text.
