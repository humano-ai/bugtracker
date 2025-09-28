Title: Fix text under scrollbar on the left
Author: rodarima
Created: Thu, 27 Feb 2025 23:12:19 +0000
State: closed

When the page is first layouted, we can then determine if the vertical scrollbar needs to be present. When the vertical scrollbar is on the left side, the whole content needs to be shifted to the right, so we need to allocate the top level widget again. The current fix simply marks the top level widget for allocation.

Fixes: https://github.com/dillo-browser/dillo/issues/359