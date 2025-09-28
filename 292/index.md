Title: Rename BrowserWindow to something else
Author: rodarima
Created: Fri, 25 Oct 2024 17:57:51 +0000
State: open

The current BrowserWindow structure is actually holding the information for the tab, not the FLTK window. In fact, there is no way to iterate among windows from Dillo itself.

--%--
From: DiegoSpirit
Date: Mon, 17 Mar 2025 10:57:49 +0000

BrowserWidget ?