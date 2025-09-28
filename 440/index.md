Title: Test font rendering in FLTK 1.4.4 with Xft backend
Author: rodarima
Created: Sun, 31 Aug 2025 22:34:36 +0000
State: open

So far it seems FLTK 1.3.11 vs FLTK 1.4.4 on Linux, using Xft on X11 and 96 DPI with scale overrided to 1 produces the same rendering results, all pixels are exactly the same:

FLTK 1.3.11:
<img width="780" height="580" alt="Image" src="https://github.com/user-attachments/assets/f90b52e8-780a-4fc0-aa70-59903826f5f5" />

FLTK 1.4.4:
<img width="780" height="580" alt="Image" src="https://github.com/user-attachments/assets/714a460e-6cd6-46ae-86a2-7ebe2e6339a9" />

Same for the website, except the scrollbard buttons:

FLTK 1.3.11:
<img width="780" height="580" alt="Image" src="https://github.com/user-attachments/assets/62ae9284-f8b5-48f9-9ceb-f9fa432c997d" />

FLTK 1.4.4:
<img width="780" height="580" alt="Image" src="https://github.com/user-attachments/assets/ba79f895-c12d-40d5-8d9c-3955e4e21dee" />

--%--
From: rodarima
Date: Sun, 31 Aug 2025 23:50:39 +0000

Using Pango seems to cause blurred text:

<img width="780" height="580" alt="Image" src="https://github.com/user-attachments/assets/0b91f80a-27f0-44f3-ba64-6a9308534769" />

Here is the close up:

<img width="2000" height="420" alt="Image" src="https://github.com/user-attachments/assets/7245f6a0-9f8f-4010-9a5d-76de69c10465" />