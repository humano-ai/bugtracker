Title: Dark mode switching
Author: rodarima
Created: Fri, 16 Aug 2024 19:11:32 +0000
State: open

Browsing the web at night or in a dark environment is generally more appealing
with dark backgrounds. However, during the day or in well illuminated rooms,
using a light background is generally preferred, as the eyes can shut the pupil
due to the large amount of light, causing the borders of letters to be sharper,
making reading easier.

It should be doable to quickly switch from a light mode to a dark mode. Ideally,
we may want to add a way to control the transition so it is not just binary, but
more gradual. However, the minimum requirement for this issue is to provide a
dark mode only.

The dark mode should change the browser UI (menus, tool bars...) but also the
content itself of the web. For the latter, we would need to define a dark mode
CSS theme, which can override the web defined colors. Similarly, we can do a
similar job to try to adjust images so that the background is dark.

Some websites can already work with a dark mode and can provide images with
adequate colors for a dark theme, without the need to adjust them.
