Title: Prepare Dillo for FLTK 1.4
Author: rodarima
Created: Thu, 15 Aug 2024 17:45:38 +0000
State: open

We should prepare Dillo to be compatible with FLTK 1.4, as currently the
configure prevents building with other than FLTK 1.3.

There may be some other changes to do with the transition.


--%--
From: rodarima
Date: Sat, 14 Sep 2024 06:50:29 +0000

Related: https://github.com/dillo-browser/dillo/issues/258

--%--
From: rodarima
Date: Mon, 21 Oct 2024 18:51:37 +0000

FLTK 1.4rc1 released: https://www.fltk.org/newsgroups.php?s22210+gfltk.coredev+v22223

One of the main changes with FLTK 1.4 is that they switched the units [to "scale units", which are DPI independent](https://www.fltk.org/doc-1.4/drawing.html#drawing_DrawingUnit). This will cause problems with images and text that is currently rendered to be shown at an specific size.

We probably will need to adjust the rendering of elements to take into the account the DPI, so they are properly rendered on the screen. Similarly, icons will need to have higher resolutions, so we can properly scale them on high DPI screens.

So far FLTK 1.4 causes gliches when scrolling, so it will remain not compatible until we can fix them:

![fltk-1 4-glitches](https://github.com/user-attachments/assets/b54b0213-6cda-4097-bb56-b94cb22eb673)


--%--
From: ghost
Date: Mon, 28 Oct 2024 13:20:22 +0000

FLTK 1.4.0rc2 has been released:
https://www.fltk.org/articles.php?L1949

I don't see any scrolling glitches as you mentioned above, so hopefully thats fixed now.


--%--
From: rodarima
Date: Mon, 28 Oct 2024 14:01:16 +0000

> I don't see any scrolling glitches as you mentioned above, so hopefully thats fixed now.

These problems are likely in Dillo not FLTK. The FLTK new commits don't change any DPI code that I can see. They are still present for me on 1.4.0rc2.

What is your screen DPI? Are you on Xorg or Wayland? If on Xorg:

```
$ xdpyinfo | grep -B2 resolution
```

Also, how did you built dillo with FLTK 1.4? Can you attach the config.log and:

```
$ ldd src/dillo
```

--%--
From: ghost
Date: Mon, 28 Oct 2024 14:40:39 +0000

It's Xorg @ 96dpi.

I set configure.ac to:

AC_PATH_PROG(FLTK_CONFIG,fltk-config)
AC_MSG_CHECKING([FLTK 1.4])
fltk_version="`$FLTK_CONFIG --version 2>/dev/null`"
case $fltk_version in
  1.4.*) AC_MSG_RESULT(yes)
         LIBFLTK_CXXFLAGS=`$FLTK_CONFIG --cxxflags`
         LIBFLTK_CFLAGS=`$FLTK_CONFIG --cflags`
         LIBFLTK_LIBS=`$FLTK_CONFIG --ldflags`;;

Then removed the original FLTK package, built the new 1.4.0rc2 from source, and installed:

$ fltk-config --version
1.4.0

Then built dillo with the new version. 

I sent you the config.log and the ldd output.

--%--
From: rodarima
Date: Mon, 28 Oct 2024 14:56:21 +0000

> It's Xorg @ 96dpi.

I don't think you will see it on 96dpi. You need a DPI value larger than 96 (but not a multiple), so it triggers the rounding problem. My screen is 101dpi which seems to be very problematic.

You may be able to fake a 101dpi and reproduce it with:

```
$ FLTK_SCALING_FACTOR=1.0539418854166667 src/dillo
```

I can also try with another 96dpi screen and see if it goes away on my end (probably).

--%--
From: ghost
Date: Mon, 28 Oct 2024 15:50:25 +0000

Ok, I start to see some glitching when doing that, and when changing the dpi higher than 96 with xrandr.

--%--
From: juanitotc
Date: Mon, 11 Nov 2024 13:56:26 +0000

For info - I just built dillo-3.1.0 against fltk-1.4.0rc3 wayland only and things seem to work

--%--
From: ghost
Date: Thu, 26 Dec 2024 15:07:15 +0000

FLTK 1.4.1 was released a while ago, and the changelog indicates that this issue might be fixed, but unfortunately there is still some of this glitching happening in Dillo with it.
![dillo-fltk-glitch](https://github.com/user-attachments/assets/910754ee-70b7-4255-927f-95cacc329fd0)


--%--
From: rodarima
Date: Thu, 26 Dec 2024 17:04:07 +0000

> FLTK 1.4.1 was released a while ago, and the changelog indicates that this
> issue might be fixed, but unfortunately there is still some of this glitching
> happening in Dillo with it.

This issue is here to act as a meta-issue, so I can cross-link all other 
fixes required for FLTK 1.4. There are several issues with FLTK 1.4 which you
can find in the issue tracker searching for "FLTK" (I should add a new label).

Until all of them are solved and I have checked that there is no big penalty in
performance, I will not consider supporting FLTK 1.4 officially. Some issues may
require large changes on Dillo, so I would not expect this to happen any time
soon.

If you are refering to this:

> Fix graphical glitches on 101 DPI screen 

This doesn't solve the issue on Dillo rendering, but it "fixes" a issue on a
FLTK test program.

> ![dillo-fltk-glitch](https://github.com/user-attachments/assets/910754ee-70b7-4255-927f-95cacc329fd0)

I have multiple patches to mitigate this issue, none good enough. There is
something wrong on the FLTK side, and until I don't find the proper solution, it
will remain broken.

There are other issues that are not so evident which would need to be solved
too. So it is safer to keep Dillo clearly broken, so we don't end up with
distributions shipping with FLTK 1.4 and a crappy patch to make it apparently
work.

One way in which you can help is by testing future patches on your hardware, so
we can determine it is fixed on a broad variety of screen resolutions. In the
meanwhile, we will have to wait.


--%--
From: ghost
Date: Thu, 26 Dec 2024 20:31:07 +0000


> Until all of them are solved and I have checked that there is no big
> penalty in performance, I will not consider supporting FLTK 1.4
> officially. Some issues may require large changes on Dillo, so I
> would not expect this to happen any time soon.

Makes sense. Hopefully distros won't be too quick to phase-out FLTK
1.3.X versions for now.

> If you are refering to this:
> 
> > Fix graphical glitches on 101 DPI screen   
> 
> This doesn't solve the issue on Dillo rendering, but it "fixes" a
> issue on a FLTK test program.

Right, that's the one that got my attention...




--%--
From: rodarima
Date: Sun, 29 Jun 2025 12:43:14 +0000

> So it is safer to keep Dillo clearly broken, so we don't end up with distributions shipping with FLTK 1.4 and a crappy patch to make it apparently work.

Given that it is taking me a while to fix this, I think it would be more useful to output the current patch under a `--enable-experimental-fltk-1.4` configure flag (or similar), so users have to manually activate it. Hopefully this will stop distributions from enabling it by default, and give users the chance to test it and potentially contribute towards a fix.