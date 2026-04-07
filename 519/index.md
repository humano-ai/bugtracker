Title: Middle button doesn't work well in Wayland
Author: Rodrigo Arias Mallo
Created: Tue, 07 Apr 2026 20:09:22 +0200
State: open

Using the middle button to paste a URL in the location bar doesn't work. Also
pressing the X that clears the current URL and navigates to the one in the
primary selection.

It seems that this problem may be a limitation of Wayland, but seems to break
the workflow designed for X11 users. Maybe we can find a workaround to keep it.

We should be able to access the selection of a Dillo window from Dillo itself
without any problem.
