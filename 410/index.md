Title: text-align affecting container positioning
Author: campaul
Created: Sat, 14 Jun 2025 05:32:28 +0000
State: closed

Given the following example:
```html
<!DOCTYPE html>
<html>
  <head>
    <style>
      .outer {
        background-color:coral;
      }
      .inner {
        background-color:aquamarine;
        text-align: center;
        max-width: 300px;
      }
    </style>
  </head>
  <body>
    <div class="outer">
      <div class="inner">Hello</div>
    </div>
</html>
```

The text in the inner div should be centered, but the inner div itself should be left aligned. Instead the text is centered and the inner div is also centered.

## Expected Behavior (taken from Firefox)
![Image](https://github.com/user-attachments/assets/1acf0ab9-61af-4edd-b40f-1472db842bae)

## Actual Behavior
![Image](https://github.com/user-attachments/assets/f52a8c12-e9a1-4238-ae4a-825a365632d5)


--%--
From: rodarima
Date: Sat, 14 Jun 2025 19:59:20 +0000

Thanks, maybe we can make a test case with a table which seems to center it properly, something like this:

```html
<!DOCTYPE html>
<html>
  <head>
    <style>
      table, tr, td {
        border-spacing: 0;
        margin: 0;
        padding: 0;
      }
      .outer {
        background-color:coral;
        width: 400px;
      }
      .inner {
        background-color:aquamarine;
        text-align: center;
        width: 100px;
        height: 50px;
      }
    </style>
  </head>
  <body>
    <table class="outer">
      <tr><td class="inner">Hello</td><td></td></tr>
    </table>
</html>
```