Title: Child combinator ignores <fieldset>
Author: ewpacol
Created: Fri, 04 Jul 2025 17:14:10 +0000
State: open

Tested with Dillo 3.2.0 on Fedora 42 via WSL 2.5.9.0

With the sample document: 

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
    <style>
      body > p {
        color: blue;
      }
    </style>
    <title>Document</title>
</head>
<body>
  <p>Body paragraph</p>
  <div>
    <p>Div paragraph</p>
  </div>
  <fieldset>
    <p>Fieldset paragraph</p>
  </fieldset>
</body>
</html>
```

Only the first paragraph should be blue since it is the only child `<p>` of `<body>`. Dillo also colors the paragraph within `<fieldset>`.

<img width="790" height="140" alt="&lt;fieldset&gt; bug demo" src="https://github.com/user-attachments/assets/8bc1920b-875e-4b85-a0c0-9fc16cadc410" />