Title: Implement margin auto
Author: campaul
Created: Thu, 29 May 2025 19:39:00 +0000
State: open

Fix for #67

This still needs more tests and documentation before it's ready to go but I wanted to post the PR to start getting feedback as early as possible. This is a big change so I expect it will end up needing many revisions.

## Overview

Some changes that were made as prerequisites:
- `style.margin` is now a length instead of just a value
- the style class has `marginLeft`, `marginRight`, `marginTop`, and `marginBottom` functions for converting back to a value. Percent and auto are treated as 0 by this function.
- `boxOffsetX`, `boxRestWidth`, and `boxDiffWidth` are moved from style to widget under the names `marginBoxOffsetX`, `marginBoxRestWidth`, and `marginBoxDiffWidth`.
- a `margin` field is added to the `Widget` class.

The main logic is as follows:
- `calcWidth` computes margin widths and returns a `BoxWidth` struct that contains the computed margin sizes instead of just the total size.
- `calcFinalWidth` sets `widget.margin.left` and `widget.margin.right` based on what it picked as the final size.
- the `marginBoxOffsetX`, `marginBoxRestWidth`, and `marginBoxDiffWidth` functions use the saved `widget.margin` values instead of `style.margin` values.

This works because `getAvailableWidth` is always called *before* any of `boxOffsetX`, `boxRestWidth` or `boxDiffWidth`. This means `calcFinalWidth` is guaranteed to have already run.


## Screenshots
The margin auto test passing
<img width="807" alt="Screenshot 2025-05-29 at 2 22 59 PM" src="https://github.com/user-attachments/assets/b6a50cfa-4b68-434c-aab0-d0b96d0bbc07" />

The dillo website correctly centered now
<img width="1169" alt="Screenshot 2025-05-29 at 2 23 33 PM" src="https://github.com/user-attachments/assets/5ef65ba4-9970-4dca-ba35-ec0f59e8fd25" />


--%--
From: rodarima
Date: Mon, 02 Jun 2025 21:32:28 +0000

Thanks a lot for the effort! I will check the implementation when I have a moment, what you describe sounds reasonable.

So far I see that with fca573fa0b3c2654f2ca178aa6556394f52be2a8 the page https://dillo-browser.github.io/25-years/index.html extends the width ignoring the max-width constraint. Can we add another test case so we prevent future regressions?