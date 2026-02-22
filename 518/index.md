Title: Blurry FLTK 1.4 fonts
Author: Rodrigo Arias Mallo
Created: Sun, 22 Feb 2026 22:40:08 +0100
State: open

Compared with FLTK 1.3 I see that in FLTK 1.4.4 and FLTK from git fonts look
more blurry.

I suspect this has to do with how the hinting and antialiasing is being done as
well as the sub-pixel placement of each glyph.

See <https://en.wikipedia.org/wiki/Font_hinting>

For Xorg, FLTK 1.3 seems to take the font configuration from .Xresources (I can
alter the hinting this way). I can reproduce the same blurry problems with the
`font` FLTK test if I open the same font "Dejavu Sans (book)".
