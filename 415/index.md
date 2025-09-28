Title: Fix newer compare output
Author: rodarima
Created: Sun, 29 Jun 2025 12:17:17 +0000
State: closed

The compare output command has now two numbers, so it will always fail if we compare it to "0".

```
++ compare -metric AE b-div.html_wdir/html.png b-div.html_wdir/ref.png b-div.html_wdir/diff.png
+ diffcount='0 (0)'
+ '[' '0 (0)' = 0 ']'
+ echo FAIL
FAIL
```

So we simply take the first one.