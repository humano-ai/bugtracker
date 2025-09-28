Title: Bad layouting of justified text with float image
Author: rodarima
Created: Mon, 25 Dec 2023 22:44:07 +0000
State: open

Reproducer:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Test floating image in paragraph with br</title>
    <style>
      body {width: 400px}
      img {width: 40%; float:right}
      p {text-align: justify;}
    </style>
  </head>
  <body>
    <i>The text below should be readable:</i>
    <p>
      <img src="https://upload.wikimedia.org/wikipedia/commons/8/8e/Dillo-icon.png" />
      This is a rather long text to increase the width.
      <br>
    </p>
  </body>
</html>
```

Renders:

![bad-layout-justify-img](https://github.com/dillo-browser/dillo/assets/3866127/b4542690-2618-4f36-9b24-198464723a25)