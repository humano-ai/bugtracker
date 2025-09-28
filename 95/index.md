Title: Consider making Dillo double-buffered by default
Author: rodarima
Created: Sat, 09 Mar 2024 11:20:14 +0000
State: open

The option `buffered_drawing` is by default set to 1, which results in single-buffered windows:

```
# Change the buffering scheme for drawing
# 0 no double buffering - useful for debugging
# 1 light buffering using a single back buffer for all windows
# 2 full fltk-based double buffering for all windows
#buffered_drawing=1
```

We may want to move the default to double buffering if there are no further issues, so we remove the artifacts on resizing the Dillo window.