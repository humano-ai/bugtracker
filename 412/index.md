Title: Out of date HSTS preload list
Author: MrMinderbinder
Created: Tue, 17 Jun 2025 11:20:01 +0000
State: open

The current HSTS preload list has not been updated in 9 years. 

The links mentioned in hsts.c are dead, the Mozilla one should be https://hg.mozilla.org/mozilla-central/raw-file/tip/security/manager/ssl/nsSTSPreloadList.inc

The latest list is over 3MB and contains over 150k entries versus ~190KB and ~10k entries for the current one. I have already taken the latest list and converted it into the format Dillo expects and startup is noticeably slower with it. Which leads me to think that HSTS preloading should just be removed as it seems a bit out of scope for a minimalist browser and there are many disadvantages compared to the value preloading brings. Or perhaps a slimmed down list for Dillo can be created?

--%--
From: rodarima
Date: Tue, 17 Jun 2025 19:20:50 +0000

I would be inclined to remove HSTS and enable `http_force_https=YES` by default, as it seems [98% of sampled sites use it since last year](https://almanac.httparchive.org/en/2024/security#transport-security). It can still be disabled from the menu for the current tab if needed.

--%--
From: MrMinderbinder
Date: Wed, 18 Jun 2025 02:57:35 +0000

There is no easy solution to this.

Potentially having a small percentage of sites fail by default does not seem appealing especially when it is likely the majority of users will not know why. Also disabling and re-enabling is annoying and users might also forget to re-enable after disabling. Even the big browsers do not dare try this yet. I also do not really want to see the work that has been done on this already thrown away.

After thinking about this some more I think we should either keep HSTS but get rid of preloading and trust on first use, accepting that there is no scalable solution to this on the browsers end or we make a smaller preload list that makes sense for Dillo. I am leaning towards making a new list that is the same size as the old one. Maybe we choose the smaller subset of domains at random from the full size list.

The slowdown is not significant on average hardware today, it is still less than a second on my system. It goes from taking tens of milliseconds with no list at all to hundreds of milliseconds. However on low end or older hardware I suspect it will be more severe. Unless you want to explore ways to parse the list more quickly?

--%--
From: MrMinderbinder
Date: Wed, 18 Jun 2025 21:53:53 +0000

> ...we make a smaller preload list that makes sense for Dillo. I am leaning towards making a new list that is the same size as the old one. Maybe we choose the smaller subset of domains at random from the full size list.

I have done this for myself and have a little script to automate it.

--%--
From: rodarima
Date: Sat, 21 Jun 2025 12:12:57 +0000

> I also do not really want to see the work that has been done on this already thrown away.

HSTS can be used as a [supercookie by an attacker](https://github.com/ben174/hsts-cookie) and track the user across a session (until you close Dillo, unlike other browsers), is not that good idea either. The whole idea should be ditched.

> Potentially having a small percentage of sites fail by default does not seem appealing especially when it is likely the majority of users will not know why.

I would rather lean towards security by always forcing HTTPS even if it involves worse potential user experience.

> However on low end or older hardware I suspect it will be more severe.

We are using the RPi 2 as the standard "oldish hardware" benchmark. Reducing startup time is always appreciated, I can try later to measure this with/without HSTS (already got rid of it).

--%--
From: niutech
Date: Fri, 11 Jul 2025 10:16:07 +0000

How about localhost or internal URLs in LAN? Often they don't have SSL. Forcing HTTPS is too strict IMO. How about trimming down the HSTS list to 10k top domains on startup and lazy load the full list in background?

--%--
From: rodarima
Date: Fri, 11 Jul 2025 21:06:54 +0000

> How about localhost or internal URLs in LAN

An easy solution is to invert the list and only add the exceptions that can use HTTP. We can add localhost by default, and let the user configure any other hosts, similar to domainrc.