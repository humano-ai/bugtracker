Title: Missing column in table with max-width and min-width
Author: rodarima
Created: Sat, 02 Mar 2024 20:59:11 +0000
State: closed

There should be three columns:
![kk](https://github.com/dillo-browser/dillo/assets/3866127/4ecc80a6-611c-44e6-be6a-664a5dd31724)

Reproducer:

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  <title>Test table in container with max-width and min-width</title>
    <style type="text/css">
      .main {
        background: lightgreen;
        max-width: 500px;
        min-width: 200px;
        padding: 10px;
      }
      table, th, td {
        padding: 0.25em;
        background: lightblue;
        border: solid 1px black;
      }
  </style>
</head>
<body>
  <div class="main">
    <table width="100%">
      <tr>
        <th>AAAAAA</th>
        <th>BBBBBB</th>
        <th>CCCCCC</th>
      </tr>
      <tr>
        <td>aaaaaa</td>
        <td>bbbbbb</td>
        <td>cccccc</td>
      </tr>
    </table>
  </div>
</body>
</html>
```

--%--
From: rodarima
Date: Sun, 10 Mar 2024 12:00:23 +0000

So, this problem is happening because the table gets an allocation smaller than the container div, even though the CSS style has a 100% width (the table `width` attribute is converted to a CSS value):

![image](https://github.com/dillo-browser/dillo/assets/3866127/db4cc206-3bf1-451a-b050-000a3810e2c6)

![image](https://github.com/dillo-browser/dillo/assets/3866127/07b5533d-4f7c-43e6-b18f-d4ea2d5feac1)


As the table doesn't have the `auto` value, it enters [this branch](https://github.com/dillo-browser/dillo/blob/d61bf779f41617bbc31c3c5697e9275a6fbb1bcd/dw/table.cc#L942-L952) when updating the table size, setting `totalWidthSpecified` to `true`:

```c++
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

This flag causes it to enter [the "case 2" branch](https://github.com/dillo-browser/dillo/blob/d61bf779f41617bbc31c3c5697e9275a6fbb1bcd/dw/table.cc#L1049) of the size calculation for tables:

```c++
   } else if (totalWidthSpecified && totalWidth > maxWidth) {
      DBG_OBJ_MSG ("resize", 1,
                   "case 2: totalWidthSpecified && totalWidth > maxWidth");

      // The width is specified (and so enforced), but all maxima sum
      // up to less than this specified width. The columns will have
      // there maximal width, and the extra space is apportioned
      // according to the column widths, and so to the column
      // maxima. This is done by simply passing MAX twice to the
      // apportioning function.

      // When column widths are specified (numColWidthSpecified > 0,
      // as calculated in forceCalcColumnExtremes()), they are treated
      // specially and excluded from the apportioning, so that the
      // specified column widths are enforced. An exception is when
      // all columns are specified: in this case they must be
      // enlargened to fill the whole table width.
```

--%--
From: rodarima
Date: Sun, 10 Mar 2024 12:08:27 +0000

The table doesn't have any width specification among columns (`numColWidthSpecified` is 0), so it enters this [branch](https://github.com/dillo-browser/dillo/blob/d61bf779f41617bbc31c3c5697e9275a6fbb1bcd/dw/table.cc#L1067-L1073), which calls the `Table::apportion2()` method:

```c++
      if (numColWidthSpecified == 0 ||
          numColWidthSpecified == colExtremes->size()) {
         DBG_OBJ_MSG ("resize", 1,
                      "subcase 2a: no or all columns with specified width");
         apportion2 (totalWidth, 0, colExtremes->size() - 1, MAX, MAX, NULL,
                     colWidths, 0);
      } else {
```
With this arguments (this is the first call):
```
dw::Table::apportion2 (this=0x5555558452a0, totalWidth=488, firstCol=0, 
  lastCol=-1, minExtrMod=dw::Table::MAX, 
  maxExtrMod=dw::Table::MAX, extrData=0x0, 
  dest=0x5555559185c0, destOffset=0)
```
The `totalWidth` is still correct, as it comes from the 500 px of the parent div, minus some border width. As `lastCol=-1` and `firstCol=0` no cell width computation is done (the table has no cells yet). It returns to `dw::Table::forceCalcCellSizes()` without modifying any cell sizes.

--%--
From: rodarima
Date: Sun, 10 Mar 2024 12:41:48 +0000

After `dw::Table::forceCalcCellSizes()` returns to `dw::Table::sizeRequestSimpl`, a [requisition correction is made](https://github.com/dillo-browser/dillo/blob/d61bf779f41617bbc31c3c5697e9275a6fbb1bcd/dw/table.cc#L112-L125):

```c++
   /**
    * \bug Baselines are not regarded here.
    */
   requisition->width =
      boxDiffWidth () + (numCols + 1) * getStyle()->hBorderSpacing;
   for (int col = 0; col < numCols; col++)
      requisition->width += colWidths->get (col);

   requisition->ascent =
      boxDiffHeight () + cumHeight->get (numRows) + getStyle()->vBorderSpacing;
   requisition->descent = 0;

   correctRequisition (requisition, core::splitHeightPreserveDescent, true,
                       false);
```

With the following values (before the `correctRequision()` call:

```
(gdb) p *requisition
$37 = {width = 12, ascent = 12, descent = 0}
```

This is taken by `dw::core::Widget::correctRequisition()` with `parent != NULL` and `quasiParent == NULL`, so [it delegates it to the parent](https://github.com/dillo-browser/dillo/blob/d61bf779f41617bbc31c3c5697e9275a6fbb1bcd/dw/widget.cc#L802-L808):
```c++
   } else if (parent) {
      DBG_OBJ_MSG ("resize", 1, "delegated to parent");
      DBG_OBJ_MSG_START ();
      parent->correctRequisitionOfChild (this, requisition, splitHeightFun,
                                         allowDecreaseWidth,
                                         allowDecreaseHeight);
      DBG_OBJ_MSG_END ();
```

The parent (the `div` which is a `dw::Textblock`) then calls `dw::core::Widget::correctReqWidthOfChild()` and then `dw::core::Widget::calcFinalWidth`:

```
(gdb)
dw::core::Widget::calcFinalWidth (this=0x5555558449f0, style=0x555555912f40,
  refWidth=-1, refWidget=0x555555849d70,
  limitMinWidth=10, forceValue=false, finalWidth=0x7fffffffd3bc)
    at ../../dw/widget.cc:938
938	   int width = calcWidth (style->width, refWidth, refWidget, limitMinWidth,
(gdb) p *finalWidth
$56 = 12
```

--%--
From: rodarima
Date: Sun, 10 Mar 2024 12:53:29 +0000

In `dw::core::Widget::calcFinalWidth()`, the width is computed by the CSS style which indicates `width: 100%`:
```
(gdb) p (100. * dw::core::style::perLengthVal_useThisOnlyForDebugging(cssValue))
$68 = 100
```
In `dw::core::Widget::calcWidth()`, `refWidth == -1` so the table [asks the div to provide the available width](https://github.com/dillo-browser/dillo/blob/d61bf779f41617bbc31c3c5697e9275a6fbb1bcd/dw/widget.cc#L906-L914):

```c++
      else {
         int availWidth = refWidget->getAvailWidth (forceValue);
         if (availWidth != -1) {
            int containerWidth = availWidth - refWidget->boxDiffWidth ();
            width = misc::max (applyPerWidth (containerWidth, cssValue),
                               limitMinWidth);
         } else
            width = -1;
      }
```

The value `width` is set to `220` by [calcFinalWidth()](https://github.com/dillo-browser/dillo/blob/d61bf779f41617bbc31c3c5697e9275a6fbb1bcd/dw/widget.cc#L680-L683) when constraining by the div min-width value:

```c++
   /* Constraint the width with min-width and max-width */
   calcFinalWidth (getStyle (), refWidth, NULL, 0, forceValue, &width);
   if (width == -1)
      width = refWidth;
```
So here is where it goes wrong.

--%--
From: rodarima
Date: Sun, 10 Mar 2024 21:02:09 +0000

I modified the test case so the text in the cells have an space, so the extremes are different. A cell can be made smaller until the longes word, and it can be made bigger until all the words are in the same line, at which point there is not need to make it bigger:

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  <title>Test table in container with max-width and min-width</title>
    <style type="text/css">
      .main {
        background: lightgreen;
        max-width: 500px;
        min-width: 200px;
        padding: 10px;
      }
      table, th, td {
        padding: 0.25em;
        background: lightblue;
        border: solid 1px black;
      }
  </style>
</head>
<body>
  <div class="main">
    <table width="100%">
      <tr>
        <th>AAA AAA</th>
        <th>BBB BBB</th>
        <th>CCC CCC</th>
      </tr>
      <tr>
        <td>aaa aaa</td>
        <td>bbb bbb</td>
        <td>ccc ccc</td>
      </tr>
    </table>
  </div>
</body>
</html>
```

With the test, the extremes now show the different values 144 and 255 for the table, for the intrinsic values:

![image](https://github.com/dillo-browser/dillo/assets/3866127/eba2fd19-1bbe-40c5-904d-4b10d1995277)

But the minWidth and maxWidth both show 200. The maxWidth should be around 500 pixels, as it is the contentWidth available in the container div.

--%--
From: rodarima
Date: Sun, 10 Mar 2024 22:53:31 +0000

The problem is caused by [this correctRequisition()](https://github.com/dillo-browser/dillo/blob/d61bf779f41617bbc31c3c5697e9275a6fbb1bcd/dw/table.cc#L124), which sets the witdh to 200 instead of leaving the correct value in 500. Adding a simple patch to comment the correction leads to a proper table:

![kk](https://github.com/dillo-browser/dillo/assets/3866127/17cbb1fa-5cd0-460d-95cb-b25cb8795aa4)

I need to investigate what is causing the correctRequisition() call to reduce the width to 200, as it should be left as is.

--%--
From: rodarima
Date: Sun, 10 Mar 2024 22:58:50 +0000

This also solves (one of) the layouting issue(s) of Hacker News:

![kk](https://github.com/dillo-browser/dillo/assets/3866127/0e4f6b25-286a-4122-afe5-2e0349d2168f)

Which had a table too small:

![image](https://github.com/dillo-browser/dillo/assets/3866127/14037099-fe6b-43f0-944b-6899e6336b84)


--%--
From: rodarima
Date: Sun, 17 Mar 2024 09:32:27 +0000

The issue was far more complicated than just the requisition being corrected to a smaller value. I needed to develop a mechanism to instrument calls to see what was going on:

![kk](https://github.com/dillo-browser/dillo/assets/3866127/93920782-dfa8-4083-b286-123bdf2c2f38)

Basically, there are two tasks to perform:

- Compute the available with of the table so it can size the columns.
- Return the size of the table.

The first task was using an incorrect width, as the Widget and Textblock logic handle the case when the CSS width is set to auto in a different way. In this branch, the min-width and max-width of CSS were not used.

The second problem is that when the available width is queried for a widget of which the width is set to auto, the min-width was setting the width first, not expanding the value to max-width in Widget::calcFinalWidth().

Fixing these two issues solves the problem.

--%--
From: rodarima
Date: Sun, 17 Mar 2024 18:40:13 +0000

The requisition correction is breaking Hacker News, but not this particular test, so let's handle that in another issue.