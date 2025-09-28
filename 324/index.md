Title: Text in right-to-left languages is rendered left-to-right
Author: eyalroz
Created: Mon, 16 Dec 2024 21:17:02 +0000
State: open

About 8% of the world uses a right-to-left script for their native language. A much larger fraction (probably over 15%) use an RTL script for a secondary language. And yet - dillo does not seem to support right-to-left scripts. Taking the most common one, Arabic: When we visit a website in Arabic, e.g.:

https://ar.wikipedia.org/

both the text on the tab, and in the rendered page, is rendered left-to-right (also, with the letters disconnected, but that will probably work better when you use a proper Unicode rendering engine). Diacritics also seem to be messed up (they're done through character which result in modifier glyphs).

--%--
From: rodarima
Date: Tue, 17 Dec 2024 04:58:43 +0000

RTL support would be nice, but I would need some help as I don't know any RTL language. Feel free to work on a patch.

Diacritics and other modifiers are a completely different issue, possibly fixed on the new FLTK, so lets focus on RTL first.