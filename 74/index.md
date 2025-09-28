Title: Incorrect padding in span or other inline tags
Author: rodarima
Created: Sun, 04 Feb 2024 14:50:20 +0000
State: open

The following render test:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Test span with padding CSS property</title>
    <style>
      span {padding: 20px; background: lightgreen}
      p {margin-top: 40px}
    </style>
  </head>
  <body>
    <p>hello <span>world</span></p>
  </body>
</html>
```
Renders properly in Firefox as:
![image](https://github.com/dillo-browser/dillo/assets/3866127/737e37c9-3f75-425d-90b0-63ded222789a)

But not in Dillo:
![image](https://github.com/dillo-browser/dillo/assets/3866127/8860f8e9-3959-4740-a845-384a3dd6b044)

The same problem seems to happen with other inline tags.
