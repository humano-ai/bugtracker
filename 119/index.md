Title: Relative goto actions
Author: rodarima
Created: Wed, 03 Apr 2024 09:46:12 +0000
State: open

From #88

> I would rather want a "relative mode". For example, if the current URL is http://example.net/examples/42.html and you type / then it will go to http://example.net/ and if you type ~/ then it will go to http://example.net/examples/~/. It would do this with all URLs, not only those ones. If you include the scheme then it is an absolute URL. (I have managed to modify Firefox to work like this.)

This can be made by adding two extra actions that select a partial segment of the path, allowing the user to type a replacement:

- `goto-path` would select only `https://example.org`<b>`/foo/bar.html`</b>
- `goto-filename` would select only `https://example.org/foo/`<b>`bar.html`</b>
- `goto` would select the whole thing, as we currently do with Ctrl+L

Then the user can type there whatever you need. Mapping those actions to `/` and `~` in `~/.dillo/keysrc` would cause a similar effect as what you describe.

CC @zzo38

--%--
From: zzo38
Date: Wed, 08 May 2024 20:59:29 +0000

This is a rather more complicated and messy way of an actual relative mode. Rather, it should be a separate option (or possibly a binding which can be mapped to the enter key while the URL is focused), which treats any entered URL as relative to the current URL. (This is also what line mode browser does, and it is more useful than what most modern browsers do, in my opinion.)

--%--
From: rodarima
Date: Wed, 08 May 2024 22:09:19 +0000

> This is a rather more complicated and messy way of an actual relative mode. Rather, it should be a separate option (or possibly a binding which can be mapped to the enter key while the URL is focused), which treats any entered URL as relative to the current URL. (This is also what line mode browser does, and it is more useful than what most modern browsers do, in my opinion.)

I think I understand what you mean, but it would be nice if you provide some more extra examples of how you would use it, as I'm not familiar with the relative addressing in the line mode browser. Specifically, where do you "type" the relative address, at the end of the URL? In another buffer? Or the URL is cleared?

I guess that when you are in the location bar you could enter a "relative addressing mode" and then you type in a special buffer (not necessarily editting the URL), and based on what you type the location is changed accordingly when you press enter.

Or you can just press a key binding to enter relative addressing by reusing the location bar, which is erased and then what you type there is a relative URL and will be applied when you press enter (assuming you don't need to see the previous address).

We could also assume that having the location URL selected via Ctrl+L allows relative addressing, so if at that point you type ~, the file part of the url is removed and you can begin typing your relative path. And the same for /. If you would like to instead type ~ or /, you simple erase the location bar first.

Apart from / and ~, are there any other special addressing symbols? Also, do you expect it to be able to paste a relative address? Does it have to be those symbols?, in non US keyboards, the tilde ~ requires Alt Gr, so I would rather prefer to have a configurable keybinding instead. As I will access the location bar with Ctrl+L, while I keep the Ctrl key pressed, I could use Ctrl+L and then Ctrl+R (for example) to select the URL and then erase the current file in the path, and begin typing the next one.

In any case, I believe that having a visual guidance would be more easy to understand for non-expert users.

As a side note, if you press Ctrl+Shift and then the arrow keys you can select the URL by parts, like in other browsers.

--%--
From: zzo38
Date: Fri, 10 May 2024 22:57:19 +0000

> I'm not familiar with the relative addressing in the line mode browser. Specifically, where do you "type" the relative address, at the end of the URL?

Line mode browser uses command-line interface; the `g` command will go to a specified relative URL (or absolute if it includes a scheme).

> Apart from / and ~, are there any other special addressing symbols?

Any text entered would be treated as a relative URL (unless it includes a scheme, in which case it is absolute), regardless of the symbols used.

(It is effectively the same as though you are following a link from the current document that has a `<a href>` with the user-entered URL, except that `<base>` is ignored and security features restricting cross-site linking are ignored; e.g. if you type `G.html` and you are currently at `http://example.org/y.html` then you will go to `http://example.org/G.html`.)

> in non US keyboards, the tilde ~ requires Alt Gr, so I would rather prefer to have a configurable keybinding instead

I agree with this; the keybinding could be mapped to "go to relative URL"; if you use that keybinding and then type a URL that includes a scheme, then it has the same effect as "go to absolute URL". (Alternatively, it could be a separate setting which affects the behaviour of the location bar. Another alternative would be a key binding which is attached to the location bar (if it supports attaching key bindings to widgets in this way; I don't know if it does) so only works if the location bar is focused; the enter key would be mapped to "go to absolute URL" by default, but you can remap it to "go to relative URL" if you prefer.)