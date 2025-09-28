Title: Hacker News table too small
Author: rodarima
Created: Sun, 17 Mar 2024 18:45:19 +0000
State: closed

The Hacker News table has some unexpected empty space in the right:

![kk](https://github.com/dillo-browser/dillo/assets/3866127/febf1ee8-eecc-444d-8618-7c110642de8c)

Related to #89 

--%--
From: rodarima
Date: Sun, 17 Mar 2024 18:52:39 +0000

This was introduced after the mercurial version.

--%--
From: rodarima
Date: Sun, 17 Mar 2024 19:11:49 +0000

Simplified reproducer:
```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hacker News table test</title>
  </head>
  <body>
    <table width="85%" bgcolor="#f6f6ef">
      <tr>
        <td bgcolor="#ff6600">
          <table width="100%">
            <tr>
              <td>
                Hello world.
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>
```

![kk](https://github.com/dillo-browser/dillo/assets/3866127/72955bb5-33f1-4d3b-8b03-ce11a72e1a97)


--%--
From: rodarima
Date: Fri, 22 Mar 2024 21:56:50 +0000

This problem seems to be hapenning due to 24bcd67df29a5418d05600b038a9283a00e555d2, as we are applying the CSS styles twice:

![kk](https://github.com/dillo-browser/dillo/assets/3866127/e312f8f1-71ab-4ae3-a681-d8e31f22c0e0)

One in `Textblock::getAvailWidthOfChild()` (which returns 300, the proper value) and another one due to my fix, which applies the relative width at the end of `Widget::getAvailWidth()` (which halves 300 into 150).

--%--
From: rodarima
Date: Fri, 22 Mar 2024 22:01:42 +0000

Reverting the commit fixes the issue, but now makes the `render/table-max-width.html` test fail (at least now we have tests). It shouldn't be relying on this behavior to size the table.

![kk](https://github.com/dillo-browser/dillo/assets/3866127/bf5c92f3-8b4f-4be4-9c86-5c4fbc9dbfcf)


--%--
From: rodarima
Date: Fri, 22 Mar 2024 22:39:25 +0000

The problem with the table-max-width test is caused by the mechanism in which we are checking if the CSS [width is effective](https://github.com/dillo-browser/dillo/blob/b0f6a3f055039c5c9c3ab651029a315a88eb6134/dw/table.cc#L942-L952), which is leaving `totalWidthSpecified` to false:

```cpp
   // CSS 'width' defined and effective?
   bool totalWidthSpecified = false;
   if (getStyle()->width != core::style::LENGTH_AUTO) {
      // Even if 'width' is defined, it may not have a defined value. We try
      // this trick (should perhaps be replaced by a cleaner solution):
      core::Requisition testReq = { -1, -1, -1 };
      correctRequisition (&testReq, core::splitHeightPreserveDescent, true,
                          false);
      if (testReq.width != -1)
         totalWidthSpecified = true;
   }
```

The problem with the correctRequisition call is that is leaving the width to -1, as is calling `Widget::getAvailWidth()` with forceValue set to false *and* the parent (the main div) has no width set (only min-width and max-width):

![kk](https://github.com/dillo-browser/dillo/assets/3866127/4e1b80d9-d789-4287-ac1e-5b036cfa525d)


--%--
From: rodarima
Date: Fri, 22 Mar 2024 22:48:10 +0000

Setting the forceValue argument to true in the `calcFinalWidth()` call of `Widget::correctReqWidthOfChild()` solves the problem and fixes all tests, but I'm not sure if it will break other cases or introduce more overhead for large documents. The documentation at least states that it is allowed:

> sizeRequestImpl (and correctRequisition) is allowed to call getAvailWidth* and getAvailHeight with forceValue set