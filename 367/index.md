Title: Custom page menu actions via dillorc
Author: acmiyaguchi
Created: Sun, 16 Mar 2025 21:55:11 +0000
State: open

The `link_action` option enables interesting expansions to dillo. For example:

- `link_action="Open in Reader View:dillo rdrview:$url"` opens a new dillo instance using the rdrview dpi plugin.
- `link_action="Copy link to clipboard:wl-copy $url"` copies a link into the wayland clipboard

It would be useful to have the same options for the current page via the page menu. 
![Image](https://github.com/user-attachments/assets/dac37361-5ffd-4053-97b4-0f50a144790e)
I propose a similar interface using `page_action` and `$url`. It would enable actions like "open current page in reader view".

These actions could be expanded even further with https://github.com/dillo-browser/dillo/issues/47 if actions could call a dillo scripting service. For example, you could open the current page using rdrview in a new tab instead of a new dillo instance. It would also be handy if actions were usable in keybindings. 


--%--
From: rodarima
Date: Mon, 17 Mar 2025 19:49:14 +0000

> The `link_action` option enables interesting expansions to dillo. For example:
> 
>   * `link_action="Open in Reader View:dillo rdrview:$url"` opens a new dillo instance using the rdrview dpi plugin.
>   * `link_action="Copy link to clipboard:wl-copy $url"` copies a link into the wayland clipboard

Selecting the location URL copies it into the primary selection (XA_PRIMARY) of X11. We may want to also copy it in the XA_CLIPBOARD and maybe the XA_SECONDARY as well. Not sure how wayland deals with that.

> It would be useful to have the same options for the current page via the page menu.
>
> ![Image](https://github.com/user-attachments/assets/dac37361-5ffd-4053-97b4-0f50a144790e)
>
> I propose a similar interface using `page_action` and `$url`. It would enable actions like "open current page in reader view".
>
> These actions could be expanded even further with [#47](https://github.com/dillo-browser/dillo/issues/47) if actions could call a dillo scripting service. For example, you could open the current page using rdrview in a new tab instead of a new dillo instance. It would also be handy if actions were usable in keybindings.

Yes, this is planned.

We can also replace the current tab with with the reader mode URL (or any other), by using something like `dillocli open --tab $tab rdrview:$url`, where $tab is provided as an envvar that uniquely identifies the current tab.