Title: Duckduckgo search is broken
Author: rodarima
Created: Fri, 08 Dec 2023 20:20:42 +0000
State: closed

When searching a term via the duckduckgo default search option, all the results are broken.

This seems to be happening because the results are a link to a duckduckgo redirection page, with a broken noscript+meta refresh tag inside the body:

Query: https://lite.duckduckgo.com/lite/?kp=-1&q=arch
First link: https://duckduckgo.com/l/?uddg=https%3A%2F%2Farchlinux.org%2F&rut=da8bb6bd1cd584ec22ab762b3b772597b539d583acf75aaab0a45c2b330f4a90

Content:
```
<html>
<head>
  <meta name='referrer' content='origin'>
</head>
<body>
  <script language='JavaScript'>window.parent.location.replace("https://archlinux.org/");</script>
  <noscript><META http-equiv='refresh' content="0;URL=https://archlinux.org/"></noscript>
</body>
</html>
```

The bug section of dillo warns about it:

```
HTML warning: line 1, The required DOCTYPE declaration is missing. Handling as HTML4.
HTML warning: line 1, <head> lacks <title>.
HTML warning: line 1, This <meta> element must be inside the HEAD section. <-- here
```

The easiest solution would be to switch to the full duckduckgo page by default (not the lite version) which seems to work fine.

--%--
From: rodarima
Date: Sat, 09 Dec 2023 14:18:05 +0000

[Here](https://salsa.debian.org/debian/dillo/-/blob/master/debian/patches/fix-duckduckgo-shortcut-in-dillorc.patch) is another solution adding the `kd=-1` argument which avoids the redirection:

```patch
Description: Fix DuckDuckGo shortcut to make result links working
Bug-Debian: https://bugs.debian/org/924357
Forwarded: no
Author: liftof+dbug@gmail.com

--- a/dillorc
+++ b/dillorc
@@ -157,7 +157,7 @@
 # You can enable multiple search_url strings at once and select from among
 # them at runtime, with the first being the default.
 # (the prefix serves to search from the Location Bar. e.g. "dd dillo image")
-search_url="dd DuckDuckGo (https) https://duckduckgo.com/lite/?kp=-1&q=%s"
+search_url="dd DuckDuckGo (https) https://duckduckgo.com/lite/?kp=-1&q=%s&kd=-1"
 search_url="Wikipedia http://www.wikipedia.org/w/index.php?search=%s&go=Go"
 search_url="Free Dictionary http://www.thefreedictionary.com/%s"
 search_url="Startpage (https) https://www.startpage.com/do/search?query=%s"
```