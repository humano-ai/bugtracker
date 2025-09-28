Title: Fix hr width exceeding available space
Author: rodarima
Created: Sun, 31 Aug 2025 12:32:42 +0000
State: closed

The hr ruler was directly using the available content width to compute its allocation. However, the width needs to take into account the border of the hr element (1 pixel on each side) to avoid making the element larger than the available space.

Co-authored-by: dogma