Title: Make Ctrl+A select all text in input
Author: rodarima
Created: Tue, 20 May 2025 21:33:12 +0000
State: closed

Users are not necessarily versed in Emacs shortcuts in text inputs. In particular, Ctrl+A should select all text in the input box as FLTK does. The problem is that we are using Emacs Ctrl+A to move to the beginning of the text, causing the select all to not work:

https://github.com/dillo-browser/dillo/blob/e8be369aa93f535519d6f63db324571286a8996b/src/ui.cc#L130-L132

Using Ctrl+Shift+A can make it reach FTLK and select all text, but is not a documented behavior.

We can add a new option to enable the Emacs handling, but not sure if this is even used.