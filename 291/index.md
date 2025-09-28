Title: Remove the 1 pixel line on the top when hiding the tabs
Author: rodarima
Created: Fri, 25 Oct 2024 17:39:29 +0000
State: open

It seems to be caused by resizing the tab bar to 1 pixel of height:

https://github.com/dillo-browser/dillo/blob/6d5b3ee329b61adfa144c4f7f9d60bbe10e04071/src/uicmd.cc#L363-L366

Setting it to 0 doesn't work well.