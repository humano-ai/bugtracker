Title: Dillo should allow <div> inside <a>
Author: steinarb
Created: Sat, 13 Jul 2024 17:58:00 +0000
State: closed

I was trying to create the structure shown here with an &lt;ul> containing &lt;li> elements containing an &lt;a> which in turns contains some &lt;div> elements for formatting.

But dillo 3.1.1 didn't like that:
```
HTML warning: line 37, Bad nesting:  <a> can't contain <div>.  -- closing <a>.
HTML warning: line 46, Unexpected closing tag: </a> -- expected </ul>.
```
I think there is a lot of modern CSS stuff that can't be made to look good if &lt;div>s aren't allowed almost anywhere, so it might be good to allow more stuff in different element contents (at least in &lt;a> but probably elsewhere as well).

Shooting for HTML5 is probably a good idea (&lt;div> is allowed in &lt;a> in HTML5), but I don't know how feasible it is?


--%--
From: rodarima
Date: Sun, 14 Jul 2024 11:48:57 +0000

Dillo already allows authors to use `div` elements inside `a` (anchor) elements **in HTML5**. For HTML 4.01 this is not allowed, so Dillo complains and closes the anchor. See https://stackoverflow.com/a/1828032.

Here are the tests, for HTML5:
```html
<!DOCTYPE html>
<html>
  <head>
    <title>Div inside a in HTML5</title>
  </head>
  <body>
    <a href="#">
      <div>
        <img src=pic.png>
        <p>This paragraph along with the picture should be hyperlink.</p>
      </div>
    </a>
  </body>
</html>
```

For HTML 4.01:
```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
            "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
    <title>Div inside a in HTML4</title>
  </head>
  <body>
    <a href="#">
      <div>
        <img src=pic.png>
        <p>This paragraph along with the picture should fail to be an hyperlink.</p>
      </div>
    </a>
  </body>
</html>
```
![html5](https://github.com/user-attachments/assets/2ae77f8a-450f-4d53-a152-3d24b6cd24fa)

![html4](https://github.com/user-attachments/assets/61edbcbc-1a00-45fe-9939-9e509a7ca991)

If you are reading that error lines in the bug meter, your document has not the proper HTML 5 doctype so it is not being parsed as HTML 5. Ensure the first line of your document is this:

```html
<!DOCTYPE html>
```

--%--
From: steinarb
Date: Sun, 14 Jul 2024 13:17:39 +0000

Ah! Right I should have read the first error line better and googled a little better:
```
HTML warning: line 1, The required DOCTYPE declaration is missing. Handling as HTML4.
```

No DOCTYPE at all in my HTML, so that's easy to fix.

Correction: I used XHTML (a long time back):
```
<html xmlns="http://www.w3.org/1999/xhtml" prefix="og: https://ogp.me/ns#">
```


(but it is hard to find the current state of things in dillo by googling)

--%--
From: rodarima
Date: Sun, 14 Jul 2024 13:57:24 +0000

> Ah! Right I should have read the first error line better and googled a little better:
> 
> ```
> HTML warning: line 1, The required DOCTYPE declaration is missing. Handling as HTML4.
> ```
> 
> No DOCTYPE at all in my HTML, so that's easy to fix.
> 
> Correction: I used XHTML (a long time back):
> 
> ```
> <html xmlns="http://www.w3.org/1999/xhtml" prefix="og: https://ogp.me/ns#">
> ```
> 
> (but it is hard to find the current state of things in dillo by googling)

AFAIK, XHTML 1.0 doesn't allow anything that is not inline inside an anchor:

https://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd
```
<!-- content is %Inline; except that anchors shouldn't be nested -->
```
But `div` is a block element, so it is not allowed inside an anchor in XHTML 1.0 either.

Also, XHTML documents also must have a doctype. The validator will help you: https://validator.w3.org/

--%--
From: steinarb
Date: Sun, 14 Jul 2024 16:49:06 +0000

For now I've removed the XML namepace from &lt;html> and given the template file an HTML5 DOCTYPE (as indicated by you in  https://github.com/dillo-browser/dillo/issues/222#issuecomment-2227316952 ) and things are behaving much nicer in dillo as well as continuing to work as before in WebKit browsers (vivaldi and chromium) and Firefox.

(in WebKit and Firefox the app is a react app, but I am aiming to have a similar experience in dillo (at least eventually), and in the process I will make https://github.com/steinarb/oldalbum more web crawler friendly)

--%--
From: rodarima
Date: Sun, 14 Jul 2024 16:57:52 +0000

> For now I've removed the XML namepace from <html> and given the template file an HTML5 DOCTYPE (as indicated by you in https://github.com/dillo-browser/dillo/issues/222#issuecomment-2227316952 ) and things are behaving much nicer in dillo as well as continuing to work as before in WebKit browsers (vivaldi and chromium) and Firefox.

Nice, closing this then.