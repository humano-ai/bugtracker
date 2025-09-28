Title: Fix text align
Author: campaul
Created: Tue, 17 Jun 2025 22:41:19 +0000
State: closed

Fix for #410 ~~and a prerequisite for finishing #403~~
Edit: this does have some interactions with #403 but turns out the fixes can be implemented independently.

There are two components to this change:
1) Only apply text alignment if the element being aligned is `inline` or `inline-block`.
2) Use the `alignStlye` from the container instead of from the element being aligned.

This PR also expands `test/text-align-center.html` with test cases for some other common scenarios


--%--
From: campaul
Date: Wed, 18 Jun 2025 05:06:52 +0000

The text-align-center test is currently failing due to imperceptible differences in font rendering. There are a few pixels different in the "r" at the end of "inner" in the 4th example and the "r" at the end of outer in the 5th example. This issue also isn't consistent across systems, as the test actually passes for me on some of the devices I've checked.

Do you think we should consider this a bug and try to get the font rendering identical, or would it be reasonable to add a small fuzz value to the comparison check? I've found a value of `-fuzz 6%` is enough to make this test pass.

## Test
![html](https://github.com/user-attachments/assets/3a2017fc-ee48-49ef-9337-095a61db7b1e)

## Reference
![ref](https://github.com/user-attachments/assets/e63cc11e-5a88-4980-be6d-304748afb013)



--%--
From: rodarima
Date: Sat, 21 Jun 2025 09:51:11 +0000

Interesting, not sure what is causing those differences. I'm leaving here a magnified picture of the problem:

![d](https://github.com/user-attachments/assets/a856c2fc-3412-40d3-ab69-b3267770d6f7)

I would be inclined to think that they use floating point numbers internally to store the position of each glyph and there may be some rounding effects moving the `r` slightlighly to the right, causing the problem in one case but not in the other. It would be heavily dependant on your platform and the specific versions of the rendering libraries you use underneath.

Could we reduce the text length (say to one word only) and see if the problem goes away? I would prefer not adding fuzzing as that may conceal other problems.

--%--
From: campaul
Date: Sat, 21 Jun 2025 16:27:54 +0000

Changing inner/outer to internal/external seems to have done the trick. Based on some other testing I did it seems like the issue has more to do with specific words than the length of the string.