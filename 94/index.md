Title: Split dw::core and dw::fltk into directories
Author: rodarima
Created: Fri, 08 Mar 2024 22:08:25 +0000
State: open

We have all Dillo widget classes in the same directory `dw/` but they are two very well differentiated groups. The dw::core namespace contains platform agnostic classes, they don't depend on FLTK. On the other hand, dw::fltk implements all the functionality over FLTK for the widgets. This separation allows adding more UI backends to Dillo.

This is well explained in the [dw overview page](https://dillo-browser.github.io/old/dw/html/dw-overview.html):

![image](https://github.com/dillo-browser/dillo/assets/3866127/a4dba9c6-9e51-47ab-9c6f-eeb903d97b5b)
