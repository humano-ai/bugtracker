Title: Only parse Content-Disposition for root URLs
Author: rodarima
Created: Sun, 18 May 2025 18:59:15 +0000
State: closed

A server may return the Content-Disposition in elements of a page like images, which would otherwise trigger several "save as" dialogs.

Fixes: https://github.com/dillo-browser/dillo/issues/398

CC: @campaul 