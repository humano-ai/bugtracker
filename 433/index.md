Title: Form inputs are not hidden with display:none
Author: rodarima
Created: Sat, 23 Aug 2025 13:05:33 +0000
State: closed

Most form elements are not hidden with `display: none`. This causes weird elements to appear in many pages that try to hide a container with forms like the Wikipedia:

<img width="780" height="580" alt="Image" src="https://github.com/user-attachments/assets/7de5e40e-79e8-4658-b28c-a057bf2a5ccf" />

A side effect of fixing this problem would seem to cause the search bar to dissapear, but that is a different issue. I would still be reachable by disabling remote CSS.

Reproducer:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Test CSS margin auto</title>
    <style>
      div {height:100px}
      .container { display: none; }
      .child {width:100px; background: brown; margin:auto }
      form { border: solid 1px blue; }
    </style>
  </head>
  <body>
    <hr>
    <p>There are some elements below, but you shouldn't see any. Disable CSS to
    see them.</p>
    <!-- inherited from container -->
    <div class="container">
      <form method="POST" enctype="multipart/form-data">

        <label for="text">First name:</label>
        <input type="text" id="text" name="text">
        <label for="cars">Choose a car:</label>
        <select id="cars" name="cars">
          <option value="volvo">Volvo</option>
          <option value="saab">Saab</option>
          <option value="fiat">Fiat</option>
          <option value="audi">Audi</option>
        </select>
        <textarea name="message" rows="10" cols="30">
          The cat was playing in the garden.
        </textarea>
        <input type="submit" id="submit" name="submit" value="Submit!">
        <input type="reset" id="reset" name="reset" value="Reset!">
        <input type="file" id="file" name="file" value="Select file...">
        <label>
          <input type="checkbox" id="checkbox" name="checkbox" value="">
          Select me!
        </label>
        <input type="hidden" id="hidden" name="hidden" value="Hidden value">
        <button>Hello</button>
      </form>
    </div>
    <hr>
    <p>The ones below are outside the form</p>
    <input style="display: none" type="text" name="out-text">
  </body>
</html>

```

It seems to be a provision for hidding elements, namely `setDisplayable(false)`, but it is implemented in `FltkResource::setDisplayed`:

https://github.com/dillo-browser/dillo/blob/f3e50968d86cd3f54f6d274a5abe72094cafd19d/dw/fltkui.cc#L525

Which is one of the two classes that elements inherit from. It is also implemented for the generic Resource:

https://github.com/dillo-browser/dillo/blob/f3e50968d86cd3f54f6d274a5abe72094cafd19d/dw/ui.cc#L274

Which does nothing. Given the multiple inheritance, it seems the generic method is being called, which causes elements to not be hidden.

The exception is FltkEntryResource::setDisplayed which defines its own, and it is properly handled:

https://github.com/dillo-browser/dillo/blob/f3e50968d86cd3f54f6d274a5abe72094cafd19d/dw/fltkui.cc#L933

We would need to build the hierarchy of elements even if they are hidden as otherwise forms won't send all the values on submission. Elements are being created on tag open (before display_none is considered) and not in tag content. This makes all the elements always visible.

A primitive solution is to redefine setDisplayed for each input, which seems to work more or less ok, but I would like for the generic FltkEntryResource::setDisplayed() method to be called. So far I was not able to make it work.

Elements not only need to be hidden, but they must not take any space. We need to make sure the allocation returns a zero area size for all elements.

--%--
From: rodarima
Date: Sat, 23 Aug 2025 13:33:46 +0000

So, there are two issues here:

- Input elements need to hide. This is relatively easy.
- Input elements need to have a zero allocation and not be able to have any interation. Not so easy, and we would need to have a way of debugging where they are, as they wil be hidden.

--%--
From: rodarima
Date: Sun, 24 Aug 2025 15:11:54 +0000

Managed to get rid of the input elements, but they are still added to the form. I should add a test to make sure that we continue to send the values properly. There is some blank space, but not sure where it is coming from:

<img width="780" height="580" alt="Image" src="https://github.com/user-attachments/assets/0c471bd8-be7d-4ab2-b549-7e7c26f28406" />

The margin is quite large:

<img width="780" height="580" alt="Image" src="https://github.com/user-attachments/assets/12cb2190-458f-4881-abfd-12e13df0afde" />

--%--
From: rodarima
Date: Sun, 24 Aug 2025 15:45:55 +0000

The big margin seems to be a side effect of another problem, the navigation bar should be placed below the title, but it fails to appear. This is not related to this issue, so it should be covered in another one. This rule fixes it:

```css
.vector-column-end { margin-top: 0 !important }
```