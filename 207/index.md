Title: Long alt text makes image too wide
Author: rodarima
Created: Wed, 26 Jun 2024 21:55:54 +0000
State: open

Long alt text in images should be split into lines, but they are not.

Reproducer:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Test image with long alt text</title>
    <style>
      div {margin: 20px; max-width: 400px; background: lightyellow; }
      img {background: lightgreen; }
    </style>
  </head>
  <body>
    <div>
		This should be 400 px wide.
    </div>
    <div>
		The following image should fail to load and show the alt text instead.
		However, the text is longer than the div width and must be split into
		multiple lines to avoid making the div longer.
      <img alt="This is the image alt text and as you can see it is longer than the containing div." src="not-existing-image.png">
    </div>
  </body>
</html>
```

![alt-text](https://github.com/dillo-browser/dillo/assets/3866127/e466d206-bf32-4ab2-a054-4f365c200b6d)


See: https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/message/PDDFE5T43OEDQOH33SDKJXCX72GN3VUI/