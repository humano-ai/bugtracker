Title: Workaround for infinite layout loop
Author: rodarima
Created: Wed, 07 Aug 2024 11:54:59 +0000
State: closed

Workaround for #236, it stops the layout loop if we have reached 1000 iterations, so we don't enter an infinite loop and hoard the CPU forever. It also stops the layouting loop each 100 iterations to return the control to the FLTK event loop, so we keep the window responsive.

There is a bug in the layouting process involving floats and white-space wrapping that should be fixed. To debug it we will probably need the debug window merged first.