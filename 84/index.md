Title: Bad rendering of https://forums.irixnet.org/thread-2819.html
Author: rodarima
Created: Tue, 20 Feb 2024 21:24:22 +0000
State: closed

Bad rendering of https://forums.irixnet.org/thread-2819.html

With 6f66fd861ef1d1bd583c31c2ce3d9c4a9896ede1 rendering is okay:
<img src="https://github.com/dillo-browser/dillo/assets/3866127/42a65669-e3cd-487d-b51c-9da7ab89e55c" width="300">


But after 24bcd67df29a5418d05600b038a9283a00e555d2 there is a problem with the layout:
<img src="https://github.com/dillo-browser/dillo/assets/3866127/00c40276-3af8-40f6-b3a2-3fd83b3e5829" width=300>


--%--
From: rodarima
Date: Mon, 26 Feb 2024 15:48:24 +0000

Reproduced:
```html
<!DOCTYPE html>
<html>
  <body>
    <table>
      <tr>
        <td width="200" style="background: lightblue">
          The next cell is 15%
        </td>
        <td width="30%" style="background: lightgreen">
          <div>
            <img src="pic.png">
          </div>
        </td>
      </tr>
    </table>
  </body>
</html>

```

--%--
From: rodarima
Date: Tue, 27 Feb 2024 22:04:55 +0000

There are two problems here:
- Using the td *attribute* `width` is **not valid**. In HTML 5 the width attribute is obsolete, and in HTML 4.01 [is deprecated](https://www.w3.org/TR/html401/struct/tables.html#adef-width-TH). Only in transitional HTML 4.01 this is acceptable.
- The available width for the text in the cell is not matching the cell margin box. This is causing missing content.

Also the HTML 4.01 specification states that the [percent length](https://www.w3.org/TR/html401/types.html#type-length) refers to the space available to the table, not the table size itself, which currently Dillo does properly:

> A percentage specification (e.g., width="20%") is based on the percentage of the horizontal space available to the table (between the current left and right margins, including floats). Note that this space does not depend on the table itself, and thus percentage specifications enable incremental rendering.