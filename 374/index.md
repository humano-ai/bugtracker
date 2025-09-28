Title: Add builtin actions to follow rel=next and rel=previous links
Author: rodarima
Created: Sun, 23 Mar 2025 21:01:12 +0000
State: open

When reading a paged document it makes sense to be able to jump to the next page by directly pressing a shortcut. The idea is to read a document, press (say) j, j, j, then you reach the bottom, then you press (for example) n, then the next page link is followed without the need to leave the keyboard (this work with one hand and hjkl is next to n).

There are some cases in the wild:

- `<link rel=next href="...">`
- `<a rel=next href="...">`

See: https://html.spec.whatwg.org/multipage/links.html#linkTypes
See: https://html.spec.whatwg.org/multipage/links.html#link-type-next