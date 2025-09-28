Title: High speed wheel causes erratic scroll
Author: rodarima
Created: Thu, 19 Dec 2024 13:13:29 +0000
State: closed

When scrolling a page using a mouse wheel, the scroll seems to work well until
the speed at which the mouse wheel is too fast. At that point the page scrolls
erratically, as if we loose events or they arrive with the opposite direction.


--%--
From: rodarima
Date: Sun, 22 Dec 2024 15:25:24 +0000

This is caused by my mouse, the same behavior is shown in xev. It looks like
after some speed it starts to send events in the opposite direction. Closing.
