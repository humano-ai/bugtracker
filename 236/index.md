Title: Infinite layout loop with github.com after loging in
Author: rodarima
Created: Wed, 07 Aug 2024 00:01:32 +0000
State: open

Infinite Layout::resizeIdle() loop when loading github.com after login in.

```
$ dillo github.com
...
Layout::resizeIdle calls = 404
Layout::resizeIdle calls = 405
Layout::resizeIdle calls = 406
...
```

--%--
From: rodarima
Date: Wed, 07 Aug 2024 10:24:03 +0000

Here is the isolated problem:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>GitHub infinite layout loop</title>
  </head>
  <body>
    <div style="display:inline-block">
      <form style="float:left">
        <input type="hidden"/>
        <button type="submit" style="white-space:nowrap; float:left">Hello</button>
      </form>
    </div>
  </body>
</html>
```

--%--
From: rodarima
Date: Sun, 25 Aug 2024 16:29:51 +0000

Another case seems to be: https://en.m.wikipedia.org/w/index.php?title=OpenVSP&action=history, https://en.m.wikipedia.org/w/index.php?title=Dillo&action=history

--%--
From: rodarima
Date: Thu, 29 Aug 2024 22:44:24 +0000

The current workaround is triggered when resizing the window.