Title: Reader Mode using rdrview
Author: dflock
Created: Fri, 03 Jan 2025 16:59:53 +0000
State: closed

The https://github.com/eafer/rdrview project is an implementation of Firefox's Reader View as a command line tool. It's written in C, and seems to work well.

I think an option to use rdrview, in combination with the exiting user mode CSS would be a really useful feature. It does a great job of distilling the page's HTML into a much simpler version (`rdrview --html` for html output) - which would be much more predictable and vastly simpler to style using user/reader mode CSS.

--%--
From: rodarima
Date: Mon, 06 Jan 2025 00:13:36 +0000

> The https://github.com/eafer/rdrview project is an implementation of Firefox's
> Reader View as a command line tool. It's written in C, and seems to work well.
>
> I think an option to use rdrview, in combination with the exiting user mode
> CSS would be a really useful feature. It does a great job of distilling the
> page's HTML into a much simpler version (`rdrview --html` for html output) -
> which would be much more predictable and vastly simpler to style using
> user/reader mode CSS.

You can extend Dillo with plugins to implement any automatic transformation that
you want. Here is a simple plugin in bash that runs rdrview and shows the page
in Dillo:

```sh
#!/bin/bash
# Copyright (c) 2025 Rodrigo Arias Mallo
# SPDX-License-Identifier: GPL-3.0-or-later

IFS= read -d '>' auth # Ignore auth
IFS= read -d '>' cmd
dir="$(dirname $(readlink -f $0))"

case "$cmd" in
  "<cmd='open_url' url='"*);;
  *) echo $cmd; exit;;
esac

url=${cmd#"<cmd='open_url' url='"}
url=${url%"' '"}

serve_error() {
  printf "<cmd='start_send_page' url='' '>\n"
  printf "Content-type: text/plain\r\n\r\n"
  echo "Error: $@"
  exit 0
}

serve_page() {
  set -x
  url="$1"
  url=${url#"rdrview:"}

  printf "<cmd='start_send_page' url='' '>\n"
  printf "Content-type: text/html\r\n\r\n"
  echo "<!DOCTYPE html>"
  echo "<html>"
  echo "<head>"
  # Optional:
  #echo "<style>"
  #cat "$dir/style.css"
  #echo "</style>"
  echo "</head>"
  echo "<body>"
  rdrview -E utf-8 --html "$url"
  echo "</body>"
  echo "</html>"
}

case "$url" in
  rdrview:*) serve_page "$url";;
  *) serve_error "unknown URL: ${url}";;
esac
```

I did a quick test but I find that sites don't really work that well as you seem
to suggest. I'll be happy to see a reasonably sized sample of sites that improve
substantially when using rdrview to consider adding it in a new git repo as a
new plugin.

We should add a mechanism to open the current page in a external tool, so that
the resulting outcome can be loaded in the same page or in a new tab. I'll need
to think about how to do it, probably with a CLI tool that can just open a new
tab like the new `link_action` option:

    page_action="Open in reader mode:dillocli new-tab rdrview:$url"

For now just prepend rdrview: in front of the URL you want to transform. Refer
to the user manual and the other plugins to see how to install and use it.


--%--
From: rodarima
Date: Tue, 07 Jan 2025 18:16:45 +0000

Some pages seem to improve with rdrview, so I assume it can still be useful.

I uploaded the plugin here: <https://github.com/dillo-browser/dillo-plugin-rdrview>

For now you will need to manually type the `rdrview:` prefix to enable the
reader mode, but I plan to make this type of transformations easier in the
future so you can do it from the menu or maybe with a keyboard shortcut.

I think we can close this issue now, as the basic support for rdrview is
available and address the rest of the improvements in other issues.


--%--
From: dflock
Date: Tue, 07 Jan 2025 23:00:05 +0000

Thank you for you help, this is awesome! I'll try out the plugin :)

As you say, readability doesn't work well/at all on every page, depends on the HTML, but when it works, it's pretty great.