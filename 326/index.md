Title: Add support for user actions in the link menu
Author: rodarima
Created: Tue, 17 Dec 2024 21:48:21 +0000
State: closed

Allows the user to define additional entries in the link menu which will
execute the given program/script. Each actions is defined using the
"link_action" option. The link URL is stored in the $url enviroment
variable and the current page in $origin, so the user can customize how
do the handling.

Here is a simple example to add three new entries:

    link_action="Debug variables:echo url=$url origin=$origin"
    link_action="Open in MPV:mpv $url"
    link_action="Open in Firefox:firefox $url"

The command is spawned in a forked process using the system() call,
which uses the shell to expand any variable. In particular, the $url
variable is set to the current URL being opened.
