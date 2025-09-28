Title: Handle PNG warnings as non-fatal
Author: rodarima
Created: Sat, 01 Jun 2024 19:39:26 +0000
State: closed

The libpng library may emit warnings when decoding a PNG image, which are non-fatal. So far we were handling them as errors and stopping the decoding process, which prevents Dillo from decoding some images. In particular, images that emit the warning:

> iCCP: known incorrect sRGB profile

Fixes: https://github.com/dillo-browser/dillo/issues/179
Authored-by: dogma