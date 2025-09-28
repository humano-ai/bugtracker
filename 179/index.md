Title: iCCP: known incorrect sRGB profile
Author: rodarima
Created: Sat, 01 Jun 2024 19:22:19 +0000
State: closed

```
Png_error_handling: https://emoji.redditmedia.com/1xwpxlk1cr3d1_t5_3l98x/wuwa_ico: iCCP: known incorrect sRGB profile
```

It seems to be a proper PNG file and sxiv can open it:

```
% file wuwa_ico.png
wuwa_ico.png: PNG image data, 64 x 64, 8-bit/color RGBA, non-interlaced
```

Attached here:
![wuwa_ico](https://github.com/dillo-browser/dillo/assets/3866127/b9c3f791-6afb-4b79-ad21-eee5139e2790)


--%--
From: rodarima
Date: Sat, 01 Jun 2024 19:25:14 +0000

Fixed in mobilized dillo by issuing a warning:
```
** WARNING **: Png warning: iCCP: known incorrect sRGB profile in file:///tmp/wuwa_ico.png
```