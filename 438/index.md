Title: Assertion `refHeight != -1 || refWidget != NULL' failed
Author: rodarima
Created: Sun, 31 Aug 2025 16:55:06 +0000
State: open

When opening two `about:splash` tabs in Dillo, then resizing the window to the minimum size, the following assert fails:

```
hop% dillo about:splash about:splash
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.5.1 1 Jul 2025
Enabling cookies as from cookiesrc...
Nav_open_url: new url='about:splash'
Nav_open_url: new url='about:splash'
dillo: ../../dw/widget.cc:1047: int dw::core::Widget::calcHeight(dw::core::style::Length, bool, int, dw::core::Widget*, bool): Assertion `refHeight != -1 || refWidget != NULL' failed.
[1]    2822457 IOT instruction  src/dillo about:splash about:splash
```

It seems the viewport height goes below 0, and it interprets it as if the height is not set, which violates the precondition that either the height or the refWidget must be known. Reproduced on current master (47ab7c704f415454fb3c908f9fe0bdebb3239ef3) and v3.2.0.