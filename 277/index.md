Title: Control the page overlap independently
Author: rodarima
Created: Sun, 13 Oct 2024 12:29:06 +0000
State: closed

Introduces the new option scroll_page_overlap to control the amount of pixels of overlap when scrolling to the next or previous page. Previously this value was taken from scroll_step, but now they are controlled independently.

Fixes: https://github.com/dillo-browser/dillo/issues/276