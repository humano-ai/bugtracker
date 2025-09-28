Title: Add custom new tab page
Author: zlqrvx
Created: Tue, 30 Apr 2024 03:06:23 +0000
State: closed

Adds the new_tab_page option which sets the page to be opened when opening a new tab.

Fixes: https://github.com/dillo-browser/dillo/issues/124

--%--
From: rodarima
Date: Thu, 02 May 2024 18:55:32 +0000

Thanks, there is a thread in the mailing list regarding this topic: https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/thread/ARQTHK24NEMENZFM6TU524FWNMWFO2GA/

Your patch doen't seem to work when a user opens a new tab by going to the File menu and clicking on the "New tab" button. It also has the problem that when setting `new_tab_page=""`, it tries to open `http:/`.

This solves it: https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/message/RNCABGTGNYIOD3DABLL2GHMNQG3AMMIE/

```diff
diff --git a/src/uicmd.cc b/src/uicmd.cc
index 88bc9b7d..fd3bd74e 100644
--- a/src/uicmd.cc
+++ b/src/uicmd.cc
@@ -770,6 +770,9 @@ void a_UIcmd_open_url(BrowserWindow *bw, const DilloUrl *url)

 static void UIcmd_open_url_nbw(BrowserWindow *new_bw, const DilloUrl *url)
 {
+   if (!url && strcmp(URL_STR(prefs.new_tab_page), "about:blank") != 0)
+      url = prefs.new_tab_page;
+
    /* When opening a new BrowserWindow (tab or real window) we focus
     * Location if we don't yet have an URL, main otherwise.
     */
```

In any case, I think I will leave this feature for the next release, so we don't block 3.1.0 for longer.

--%--
From: otonoton
Date: Sat, 04 May 2024 20:39:07 +0000

Would it be better to switch to `strncmp`?

--%--
From: rodarima
Date: Sun, 09 Jun 2024 10:25:18 +0000

Merged in https://github.com/dillo-browser/dillo/pull/188 after modifying Alex patch.