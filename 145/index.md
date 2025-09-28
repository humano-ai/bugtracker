Title: Implement force https mode.
Author: zlqrvx
Created: Sun, 28 Apr 2024 03:07:25 +0000
State: closed

This pull request implements an option to force all http urls to be upgraded to https, similar to [HTTPS-Only Mode](https://support.mozilla.org/en-US/kb/https-only-prefs) in Firefox.

This is implemented by changing all http urls to https when they are created in a_Url_new.

A http_force_https preference is provided as well as a menu bar item to toggle this mode.