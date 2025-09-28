Title: Doubled border/phantom box for images with block display style
Author: bblhd
Created: Sun, 29 Dec 2024 03:03:22 +0000
State: open

Hello! When styling an image in dillo, if you give it the property `display: block;` and also a border, such as `border: 1px solid black;`, it will draw two borders around the image, one around the image itself, and one where the image's margin should be, also doubling the margin.

It seems to be creating a box around the image with the same style properties as the image?

### Minimal demonstration:
```
<!DOCTYPE html>
<html>
<head>
<title>Demonstation</title>
<style>*{margin: 10px; padding 10px; border: 5px solid black; display: block;}</style>
</head>
<body>
<div style='border-color: blue;'>
<img style='border-color: red;' src='https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Youngkitten.JPG/320px-Youngkitten.JPG'/>
</div>
</body>
</html>
```

### How dillo renders it (for me):
![doubledborder](https://github.com/user-attachments/assets/e251228a-dc45-49c6-80db-369844e9ab1b)


--%--
From: rodarima
Date: Sun, 29 Dec 2024 15:57:04 +0000

Thanks for the report, it is hard to find a proper issue nowadays, even less
with a working reproducer.

This seems to be coming from the current implementation for block and
display-block, which is internally done by wrapping the image in another
container which seems to be also getting the same style.

I'll try to find a quick workaround. Otherwise I'll probably address this after
3.2.0, as this may require changing the way the block elements are implemented.


--%--
From: joshas
Date: Thu, 02 Jan 2025 18:54:19 +0000

Are you aware, that by using CSS universal selector *, you are styling all HTML elements on the page, including `<html>` and `<body>` ? Interesting to note, that Dillo does not render `<head>`, `<title>` and `<style>` elements, when they get `display: block` style applied.

--%--
From: bblhd
Date: Fri, 03 Jan 2025 01:55:36 +0000

> Are you aware, that by using CSS universal selector *, you are styling all HTML elements on the page, including `<html>` and `<body>` ? 

Yes, hence the differently coloured borders, though I didn't know that some browsers could interpret head/title/style tags as block elements until today