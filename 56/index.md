Title: Split protocol and content handling in plugins
Author: rodarima
Created: Tue, 09 Jan 2024 22:47:20 +0000
State: open

Currently, the Dillo plugin design shows some shortcomings.

Considering the plugin for [man pages](https://github.com/dillo-browser/dillo-plugin-man) that can load a manual page with `man:bash` and present it as a HTML page. The plugin breaks when trying to open a page from a file or from any other protocol like https.

What is happening here is that we have plugins performing two actions at the same time:

- Adapt the protocol to HTTP.
- Convert the content in the document to HTML.

These two actions are coupled in the same plugin. For example, we cannot open a local man page using only the conversion to HTML feature of the man plugin.

Ideally, plugins should offer both actions, but also allow Dillo to use them on their own if needed. This way, opening a file with `file:/path/to/man/page.1` will use the `file:` protocol plugin to make the request and get the content and then the content type of the file will be used to select how to present it. In this case, by sending it to the man plugin function that converts it to HTML.

Similarly, the rules to select which content handler is used can be made to match the URL, so a single page can be forwarded to one or several content handling plugins.

Here is an example of a possible configuration file, inspired by the syntax of [smtp.conf(8)](https://man.openbsd.org/smtpd.conf):

```sh
# Finds the corresponding man page and fetches it decompressing if needed.
# The content type will be set to "text/troff".
match protocol "man" adapter "/path/to/man.adapter.dpi"

# Then the man page will be read from the stdin and HTML will be written in the stdout,
# with the appropriate patching to fix HTML problems. This would also work for remote
# manual pages.
match content "text/troff" filter "/path/to/man.filter.dpi"
```

This also would implement support for any viewer or media player. For example, to open YouTube pages in Invidious (so comments can be loaded) and play the video in a player:
```sh
# Redirect a YouTube URL to a working instance of Invidious, so we can render it without JS
match url "http[s]://[www\.]youtube\.com" adapter "yt2invidious.sh"
# Then just play it with vlc, but only if the URL comes from Invidious
match url "/videoplayback.*googlevideo" content "video/.*" command "vlc"
```

This could also be used to fix other pages that have a broken HTML or CSS, or even try to repair pages so they don't require JS for the most common usage:
```sh
# Apply special CSS for reddit
match host "[www\.]reddit\.com" style "reddit.css"
# Fix HTML in Twitter and load special CSS
match host "twitter\.com" filter "twitter.filter.dpi" style "twitter.css"
```

The `style` could be injected by a dpi filter plugin, but it would require plugins to properly parse the HTML. Using a specific option for it allows Dillo to preload the CSS before the server is even contacted and enforce it to have always higher priority.

Both the protocol adapters and filters work in stream mode, so they can begin piping data to the next stages and eventually to the screen much earlier than the complete page is fetched.

--%--
From: rodarima
Date: Sun, 14 Jan 2024 16:12:12 +0000

One of the problems of using a simple stdin/stdout program to rewrite the HTML is that we would need to run it on every website. This would cause parsing the HTML multiple times, at least one for each plugin, which would be wasteful.

A plugin would benefit from being able to work directly on the DOM tree, but that would restrict the plugins to interface via an API instead of a simple I/O interface. Writting plugins should be easy.

--%--
From: rodarima
Date: Sun, 21 Jan 2024 12:18:18 +0000

I created #65 to discuss the design of the "filter" types of plugins.

--%--
From: rodarima
Date: Sun, 14 Apr 2024 13:43:46 +0000

Regarding the matching rules, there are several stages at which a plugin may need to be hooked:

- Pre-request: Before any network activity is made. Allows rewriting the URL for example http to https or changing the host. We may want to create an small syntax for this stage so it can be manipulated as text. Here is were protocol handlers would wook to.
- Request: When a connection is opened with a server, we may still want to modify the HTTP headers before sending them.
- Response: Data coming from the server may need to be adjusted or rewritten. That includes HTTP headers as well as the content itself. Here is where all those content handling plugins would hook to.

Plugins may operate as HTTP servers as well (CGI), so we can for example allow cookies to work for plugins too.