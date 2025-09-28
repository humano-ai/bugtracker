Title: Protect against compression bomb
Author: rodarima
Created: Sat, 26 Jul 2025 11:02:43 +0000
State: open

Dillo will try to uncompress the complete HTML, which likely will cause it to run out of memory:

https://ache.one/notes/html_zip_bomb (safe to open)
```
https://ache.one/bomb.html (will likely crash your browser)
```

I think this could be prevented by capping the maximum Content-Length we would display before a question is asked to continue. However, this won't work if the server doesn't provide the header. Ideally we should cap this at the decoder.