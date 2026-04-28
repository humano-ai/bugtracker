Title: Tracking problems of Dillo 3.0.5 on Debian
Author: rodarima
Created: Fri, 22 Nov 2024 22:44:39 +0000
State: open

Debian continues to ship with [Dillo
3.0.5](https://packages.debian.org/search?keywords=dillo), even if we have made
already four [releases](https://dillo-browser.org/release/) since we
took over the maintenance (see this [HN
post](https://news.ycombinator.com/item?id=38847613)). For reference, **Dillo
3.0.5 was released in 2015**.

Several users are affected by issues that were fixed either by the original
developers of Dillo (but never made it to a release) or fixed by us in the last
releases (after 3.0.5).

Other distributions like Ubuntu, Raspbian or Linux Mint use the Debian packages,
so they also include the outdated Dillo. This is particularly painful as the
users are typically newcomers, and there is not much chance they will even
realize they are using a **10+ year old release**.

I'll try to keep here a list of those issues I find on the web, sorted by time.

---

## 2024-11-06 - https://youtu.be/RjzQNngysh4?t=371

> Sometimes I have trouble visiting this website (api.invidious.io), like I
> think it may be block in some DNS...

On Dillo 3.0.5-7+b1 it doesn't work:

```
Nav_open_url: new url='https://api.invidious.io/'
** ERROR **: [Dpi_read_comm_keys] No such file or directory
Dpi_blocking_start_dpid: try 1
[dpid]: a_Misc_mksecret: 95fcad05
dpid started
40776AE697730000:error:0A000438:SSL routines:ssl3_read_bytes:tlsv1 alert internal error:../ssl/record/rec_layer_s3.c:1590:SSL alert number 80
```

This is probably related to the missing handling of TLS alerts on OpenSSL. On Dillo 3.1.1 it works fine:

![invidious](https://github.com/user-attachments/assets/002af7cf-f0cd-4cc8-a477-5b805a2d9e8e)


---

## 2024-11-22 - https://forums.raspberrypi.com/viewtopic.php?p=2270962 

> I launched Dillo, it locked up, or at least failed to connect with connect.raspberrypi.com. Wifi is up as sudo apt update worked fine.
> [...]
> Do any of the images include midori or a browser that a 2 Zero can actually launch and use?

Similar SSL problem on Dillo 3.0.5-7+b1:

```
Nav_open_url: new url='https://connect.raspberrypi.com/'
Nav_open_url: new url='https://connect.raspberrypi.com/devices'
Nav_open_url: new url='https://connect.raspberrypi.com/sign-in'
NumPendingStyleSheets=1
NumPendingStyleSheets=2
NumPendingStyleSheets=3
40D74863E4710000:error:0A000410:SSL routines:ssl3_read_bytes:sslv3 alert handshake failure:../ssl/record/rec_layer_s3.c:1590:SSL alert number 40
40E7A918607B0000:error:0A000410:SSL routines:ssl3_read_bytes:sslv3 alert handshake failure:../ssl/record/rec_layer_s3.c:1590:SSL alert number 40
```

But works fine on Dillo 3.1.1, although it probably require [enabling cookies](https://dillo-browser.github.io/user_help.html#cookiesrc) to login.

![raspberri](https://github.com/user-attachments/assets/e0d0082c-9f4c-4bab-b52e-6372f9e683f1)

---

## 2025-09-11 - debian.org

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1114901

```
Package: dillo
Version: 3.0.5

Hi,
trying to open debian.org with dillo browser.
got this error message from dillo :

"error 421
Misdirected Request
The client needs a new connection for this request as the requested host 
name does not match the Server Name Indication (SNI) in use for this 
connection.

Apache/2.4.65 (Debian) Server at debian-facile.org Port 443
"

trying to open debian.org with dillo git release 3.2.0 works.
```

At least the user did test 3.2.0 this time.

--%--
From: travis-jeans
Date: Wed, 05 Mar 2025 09:32:19 +0000

I found this page because I downloaded the "latest" version of Dillo from the Debian repository today, which is 3.0.5... but I was having a lot of difficulty getting certain pages to load. I could load a few https websites. An example is [ABC News](https://www.abc.net.au/news), though it looks like there isn't support for CSS3. Is it possible to update the debian repository with the latest version of dillo?

Some errors:
```
a_Dicache_cleanup: length = 142
Nav_open_url: new url='https://www.abc.net.au/news'
no values for shorthand property 'padding'
no values for shorthand property 'padding'
no values for shorthand property 'border-color'
no values for shorthand property 'border-color'
no values for shorthand property 'border-color'
...
no values for shorthand property 'padding'
a_Dicache_cleanup: length = 142
```

--%--
From: Rodrigo Arias Mallo
Date: Tue, 28 Apr 2026 20:37:47 +0200

## 2026-04-28 - https://snac.mro.name/

Another case reported by Mindiell in IRC with Dillo 3.0.5 from Debian:

> It seems that dillo is stuck when I try to go on this URL :
> https://snac.mro.name/

The host resolves only to IPv6:

    % getent hosts snac.mro.name
    2a03:4000:5:f44:affe:beef:cafe:deaf snac.mro.name

In Dillo 3.0.5 from Debian gets stuck:

    % dillo -v
    Dillo version 3.0.5

    % dillo https://snac.mro.name
    Domain: Default accept.
    dillo_dns_init: Here we go! (threaded)
    Disabling cookies.
    Nav_open_url: new url='https://snac.mro.name'
    (stuck)

But with Dillo 3.3.0 we successfully resolve the domain and proceed to connect:

    % dillo -v
    Dillo v3.3.0
    Libraries: fltk/1.4.5 jpeg/3.1.4.1 png/1.6.56 webp/1.6.0 zlib/1.3.2 brotli/1.2.0 OpenSSL/3.6.2
    Features: +GIF +JPEG +PNG +SVG +WEBP +BROTLI +XEMBED +TLS +IPV6 +CTL

    % dillo https://snac.mro.name
    Domain: Default accept.
    dillo_dns_init: Here we go! (threaded)
    TLS library: OpenSSL 3.6.2 7 Apr 2026
    Enabling cookies as from cookiesrc...
    paths: Cannot open file '/home/ram/.dillo/hsts_preload': No such file or directory
    paths: Using /usr/local/etc/dillo/hsts_preload
    [dpid]: terminated normally (0)
    Nav_open_url: new url='https://snac.mro.name'
    Dns_server [0]: snac.mro.name is 2a03:4000:5:f44:affe:beef:cafe:deaf
    Connecting to [2a03:4000:5:f44:affe:beef:cafe:deaf]:443
    ...

