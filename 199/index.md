Title: Allow actions to be defined to handle URLs
Author: rodarima
Created: Fri, 14 Jun 2024 20:32:45 +0000
State: closed

Implements the logic to read rules from ~/.dillo/rulesrc which define custom actions to handle a URL. Here is an example:

  action "Open with MPV" shell "mpv $url"
  action "Open with MPV (only audio)" shell "mpv --no-video $url"
  action "Open with Firefox" shell "firefox $url"

The standard input and output is still redirected to the same file descriptor as Dillo.

The commands are spawned in a forked process using the system() call, which uses the shell to expand any variable. In particular, the $url variable is set to the current URL being opened.