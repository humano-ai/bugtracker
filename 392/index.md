Title: Usage of SSL websites disables the onscreen keyboard effects
Author: lm2lm2
Created: Tue, 06 May 2025 10:37:50 +0000
State: open

postmarketos v24.12 updated

dillo 3.2

1. open dillo browser
2. go to bookmarks
3. select 68k.news
4. validate cert
5. go to "change" (language)
6. select french
7. anywhere in dillo you will try to enter by keyboard, the keyboard is just disabled, in webpage as well as in address field.

the On screen keyboard appears well, but it does not "prints" characters at all.

pmos 
https://gitlab.postmarketos.org/postmarketOS/pmaports/-/issues/3696

--%--
From: rodarima
Date: Mon, 02 Jun 2025 21:42:56 +0000

This seems to be a known issue with Phosh and FLTK. You may want to try the [Mobilized fork](https://www.toomanyatoms.com/software/mobilized_dillo.html) in the meanwhile.
