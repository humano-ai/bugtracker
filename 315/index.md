Title: Text sized with "pt" appears to be too big
Author: kaimac1
Created: Tue, 03 Dec 2024 17:40:34 +0000
State: closed

I was looking at why some of the text on search.marginalia.nu is really big.

    <!doctype html>
    <style>body {font-family: serif;}</style>
    <span style="font-size:20px">20px text</span><br>
    <span style="font-size:15pt">15pt text</span><br>

In dillo vs firefox:

![2024-12-03-173617_381x207_scrot](https://github.com/user-attachments/assets/0a595e71-87d2-4ca2-9f6e-5ec142674e54)



--%--
From: rodarima
Date: Tue, 03 Dec 2024 18:08:44 +0000

Thanks for the report, this may be related to your screen resolution.

Which commit of Dillo are you using and what is your screen DPI? On Xorg I get:

```
% xdpyinfo | grep -B 2 resolution
screen #0:
  dimensions:    1920x1080 pixels (483x272 millimeters)
  resolution:    101x101 dots per inch
```

And renders "okay":

![pt](https://github.com/user-attachments/assets/89506d87-a21e-4853-a0ff-462d90f4e0cd)


I have a patch to make marginalia render better, but is not public yet:

![marginalia-new](https://github.com/user-attachments/assets/321b1e62-08a8-4486-b38e-18e3dba27d22)



--%--
From: kaimac1
Date: Tue, 03 Dec 2024 18:28:58 +0000

I'm running the latest commit, https://github.com/dillo-browser/dillo/commit/d4f56d0d8d07dd45600eca76551c011e290e4520

    $ xdpyinfo | grep -B 2 resolution
    screen #0:
      dimensions:    3840x2160 pixels (621x341 millimeters)
      resolution:    157x161 dots per inch


--%--
From: rodarima
Date: Tue, 03 Dec 2024 19:06:50 +0000

I think that is correct for the pt units.

A pt is defined as 1pt = 1/72 of an inch. So 15 pt is 0.2083 inches (or 5.29 mm).

As your screen has ~160 pixels per inch, 15 pt = 15/72 in * 160 pixels/in = 33.3 pixels.

I have marked in your image boundary lines at 20 px and 33 px:

![1pt](https://github.com/user-attachments/assets/85e10b86-a2e3-4d0e-8171-8a69d13f1a16)

Now, the problem is that Dillo will render "20 px" as 20 screen pixels, while this is not the case for [the "px" unit used in CSS/HTML](https://www.w3.org/TR/css-values-4/#reference-pixel). A web px unit is the angle a pixel has in a 96 DPI at an arm length. So in your screen, 20 CSS pixels should be also around 20 * 160 / 96 = 33.3 screen pixels.

This is something that will be addressed by FLTK 1.4.0, when we manage to solve the rest of the issues.

Now, I don't know why on Firefox is being rendered that small, but that doesn't seem to be the size it should have. You can check this by making a div of, say, 5 inches (or 15 cm) and measuring it with a rule.

```html
<!doctype html>
<html><head><title>Rule</title></head><style>
div {
  background: lightgreen;
  border: 1px solid black;
  height:100px;
  margin: 1em;
}
</style><body>
<div style="width:5in">5 inches wide</div>
<div style="width:15cm">15 cm wide</div>
</body></html>
```

--%--
From: kaimac1
Date: Tue, 03 Dec 2024 20:53:57 +0000

Ok, thanks for the info!

What you are saying makes sense, which is that on my screen 15pt should be 33 pixels and 20px should also be around 33 pixels.

Does this make sense as a possible explanation?

According to [this](https://www.w3.org/Style/Examples/007/units.en.html#units), images should ("by default") be displayed such that one image pixel maps to 1px. And in firefox (and dillo), images are displayed with 1 image pixel = 1 display pixel. Therefore 1px = 1 pixel, which might explain why firefox's 20px text is 20 pixels high. And if 15pt should be about the same size as 20px, it will also be around 20 pixels. So rather than scaling images up by ~50%, the absolute pt/in/cm units are being scaled down ~33%. That's what I see with your ruler example - the 15cm div is only about 10cm long on my screen. That link also says that the absolute units are only required to be accurate on high resolution output devices, meaning printers.

--%--
From: rodarima
Date: Tue, 03 Dec 2024 21:42:30 +0000

> Does this make sense as a possible explanation?
> 
> According to [this](https://www.w3.org/Style/Examples/007/units.en.html#units), images should ("by default") be displayed such that one image pixel maps to 1px.


I don't interpret this from the document:

> A photo with a 600 by 400 resolution will be 600px wide and 400px high. The pixels in the photo thus do not map to pixels of the display device (which may be very small), but map to px units.

One image pixel should be mapped to one CSS px unit (0.0213 degrees). So if you have a super high density screen, it will continue to have the same physical size (eye angle) as in a low density display, which is good.

The CSS px units should be the same among images, divs or font sizes.

You can see this by opening the above image in Firefox and Sxiv. In my case with 101 DPI is just slightly bigger, which is expected:

![ff](https://github.com/user-attachments/assets/03b75e29-0c1e-40b6-b9ea-84a85894643c)

> And in firefox (and dillo), images are displayed with 1 image pixel = 1 display pixel.

In Dillo yes (our limitation), but in Firefox it shouldn't be the case. See:

![dillo](https://github.com/user-attachments/assets/a873510e-1a0e-495b-9475-20258f9d1ce1)

> Therefore 1px = 1 pixel, which might explain why firefox's 20px text is 20 pixels high. And if 15pt should be about the same size as 20px, it will also be around 20 pixels.

I suspect that Firefox is assuming your screen has 96 DPI. Check:

https://wiki.archlinux.org/title/HiDPI#X_Resources

You can query what value you have in your system with `xrdb -query | grep dpi`, which should be around 160 not 96.

After setting it to your DPI, you should see the 15 cm sized div measure 15 physical cm in Firefox (unless you have other scale settings).

> So rather than scaling images up by ~50%, the absolute pt/in/cm units are being scaled down ~33%. That's what I see with your ruler example - the 15cm div is only about 10cm long on my screen. That link also says that the absolute units are only required to be accurate on high resolution output devices, meaning printers.

I would say that not having the 15cm div measure 15cm means something is not well configured on your system if you were planning to have a scale factor of 1.

--%--
From: kaimac1
Date: Tue, 03 Dec 2024 22:25:56 +0000

>> And in firefox (and dillo), images are displayed with 1 image pixel = 1 display pixel.
> In Dillo yes (our limitation), but in Firefox it shouldn't be the case.

I think we disagree that this is a bad thing. It's not that Firefox has the "wrong" DPI, it's that it is essentially set to have a device pixel ratio of 1 pixel per "px", which I like. I don't want images to be upscaled and therefore slightly blurry. If I had a very high DPI display, maybe I would use a DPR of 2. 

A DPR of 1 necessarily means absolute units aren't the right size, unless you have a 96 DPI display, but that's ok. I think what you are saying is that the DPR should be set to a fractional value such that absolute units like inches are displayed correctly. I don't think that's right and I wouldn't want dillo to do that because it would mean blurry images - but I guess there'll be a setting for this when it's on the new FLTK version :)

--%--
From: rodarima
Date: Tue, 03 Dec 2024 22:50:30 +0000

> I think we disagree that this is a bad thing. It's not that Firefox has the "wrong" DPI, it's that it is essentially set to have a device pixel ratio of 1 pixel per "px", which I like. I don't want images to be upscaled and therefore slightly blurry. If I had a very high DPI display, maybe I would use a DPR of 2.

I understand. I also don't think is a bad thing if you are explicitly configuring it that way. Nowadays, retina display are causing websites to use images with a size of at least double the CSS px size specified in their size, so they are still rendered okay in 2*96 DPIs displays. But not all websites do this, and it also incurrs in larger transfer sizes.

> A DPR of 1 necessarily means absolute units aren't the right size, unless you have a 96 DPI display, but that's ok. I think what you are saying is that the DPR should be set to a fractional value such that absolute units like inches are displayed correctly. I don't think that's right and I wouldn't want dillo to do that because it would mean blurry images - but I guess there'll be a setting for this when it's on the new FLTK version :)

Yeah, I think setting the DPI to 96 and knowing an inch won't match is fine. It also bothers me a bit when I see blurry images in Firefox, so I have an extra reason to go and use Dillo instead :)

Feel free to close this if the pt concern is addressed.