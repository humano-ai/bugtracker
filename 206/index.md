Title: Handle http-equiv refresh if the user wants to
Author: rodarima
Created: Tue, 25 Jun 2024 18:56:41 +0000
State: open

Some users may want to enable support for the meta http-equiv refresh tag, which allows pages to automatically refresh or redirect to another URL. This is particularly useful to make Dillo work as a monitor panel in a page that shows information and [refreshes from time to time](https://forums.raspberrypi.com/viewtopic.php?t=330705) or to [redirect to a non-JS page](https://github.com/dillo-browser/dillo/issues/204).

We can implement an option that allows users to choose what to do, with the current default of ignoring refreshes and showing a message for redirects.