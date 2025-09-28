Title: Add zoom control
Author: rodarima
Created: Sun, 05 May 2024 18:36:05 +0000
State: closed

Fixes #21 

--%--
From: rodarima
Date: Sun, 05 May 2024 18:37:03 +0000

Control-+ doesn't seem work in US keyboard layouts.

--%--
From: niutech
Date: Sun, 05 May 2024 22:45:32 +0000

@rodarima Please use `Ctrl =` instead of `Ctrl +`, so that it doesn't require pressing `Shift`, which is consistent with major web browsers.

Also please add `Ctrl 0` to reset zoom to 100%. 

--%--
From: rodarima
Date: Sun, 09 Jun 2024 19:58:06 +0000

> @rodarima Please use `Ctrl =` instead of `Ctrl +`, so that it doesn't require pressing `Shift`, which is consistent with major web browsers.

It should work now both for US and EU keyboards. Both Ctrl + and Ctrl = cause a zoom increase.

> Also please add `Ctrl 0` to reset zoom to 100%.

Should be working too.

--%--
From: niutech
Date: Mon, 10 Jun 2024 09:09:09 +0000

@rodarima Thank you!