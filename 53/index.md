Title: Consider other forks of Dillo
Author: bkil
Created: Thu, 04 Jan 2024 09:35:57 +0000
State: open

Instead of encouraging contribution to this repository forked from source code many years old, please migrate all issues & contribution to the vastly more advanced Dillo-Plus. Thanks.

--%--
From: kuchikuu
Date: Mon, 08 Jan 2024 13:35:06 +0000

Well, I am neutral but I would like [rodarima](https://github.com/dillo-browser/dillo/commits?author=rodarima) to comment because I plan on making some commits and NOW I'm not sure whether I should do it here or to Dillo-plus.

[rodarima](https://github.com/dillo-browser/dillo/commits?author=rodarima), do you plan on adding minor fixes and enhancements only (keeping it old-school) or are you willing to add more functionality to Dillo? 

--%--
From: rodarima
Date: Mon, 08 Jan 2024 14:22:30 +0000

> Well, I am neutral but I would like [rodarima](https://github.com/dillo-browser/dillo/commits?author=rodarima) to comment because I plan on making some commits and NOW I'm not sure whether I should do it here or to Dillo-plus.
> 
> 
> 
> [rodarima](https://github.com/dillo-browser/dillo/commits?author=rodarima), do you plan on adding minor fixes and enhancements only (keeping it old-school) or are you willing to add more functionality to Dillo? 

(I'm away from computer) I plan to continue with the original objective of Dillo which is bring access to the web to most devices. Adding new features is fine too.


--%--
From: bkil
Date: Mon, 08 Jan 2024 16:31:25 +0000

I've opened a clone of this issue for dillo-plus. The maintainer is open for collaboration, with the condition that BSD support is a must for them.
* https://github.com/crossbowerbt/dillo-plus/issues/21

--%--
From: rodarima
Date: Mon, 08 Jan 2024 20:08:06 +0000

Hi, sorry I couldn't answer very well. I'll expand my reply a bit and also mention @crossbowerbt to join the thread.

> Instead of encouraging contribution to this repository forked from source code many years old, please migrate all issues & contribution to the vastly more advanced Dillo-Plus.

It is nice to have multiple forks of Dillo to test other features or experiment new concepts. And there is no problem contributing in one repository or the other as most of the patches can be transferred among repositories without much work (you can see that we recommend people to also check other forks in the README.md, no gatekeeping). I should add a contributing guide so it becomes a bit clearer for someone to send a patch or PR.

Regarding dillo-plus, some features they have introduced are interesting and I would like to eventually introduce in Dillo. In fact, my initial idea of creating an organization is to eventually converge the several Dillo forks into one, to join forces.

> I've opened a clone of this issue for dillo-plus. The maintainer is open for collaboration, with the condition that BSD support is a must for them.

We run the tests on FreeBSD in the CI, and other BSD systems could be added too (contributions are welcome), but getting more human testers in BSD systems would be nice.

I have in my TODO list to check in detail the commits of dillo-plus, but right now the first priority is to stabilize the version 3.1 so we can finally make a release. Check https://github.com/dillo-browser/dillo/milestone/1 to see what is planned.

From your issue in dillo-plus:

> Otherwise, if our objectives are different, I'm open to periodically exchange patches to improve both projects

I hope we can eventually converge into similar objectives but exchanging patches is also fine.

Regarding the title of this issue "Please archive this repository", I'll switch to something more descriptive as I don't plan to archive this repository for now, but is nice to still keep this issue for reference.

--%--
From: bkil
Date: Mon, 08 Jan 2024 22:07:47 +0000

Glad to hear we are all on the same page. It helps future exchange of patches if the codebase (or at least the core architecture) is as close as possible between the two repositories.

This will be crucial in the future as I was considering contributing JavaScript0 support later on and it would be great if it would be enough to develop it only once within a single module, as some small interface hooks will also be required.

--%--
From: crossbowerbt
Date: Tue, 09 Jan 2024 05:56:00 +0000

Hello everyone! Nice to see that people still like and work on dillo and that the project isn't dead.

I'd like to share what I'm planning to implement this year (in my spare time, so don't hold your breath...):
- re-implement the download module internally to handle more protocols (ftp, gopher, gemini) without requiring an external tools
- re-implement the FTP module in C to avoid the wget dependency
- adding support for SVG and WEBP images (if and only if the libraries needed require few and simple dependencies)
- rewrite all DLS (the external scripts dillo-plus uses to add additional functionalities) to use only standard shell scripts and simple external tools (and so remove python dependency)
- various fixes to css, ui, markdown parser, etc...

--%--
From: crossbowerbt
Date: Tue, 09 Jan 2024 06:02:55 +0000

I see that your repo contains dillo plugins for gopher and man, written in C. I didn't know they existed, i should consider integrating them in my fork

--%--
From: bkil
Date: Tue, 09 Jan 2024 11:41:16 +0000

@crossbowerbt  NetSurf uses libsvgtiny for minimalism:

* https://git.netsurf-browser.org/libsvgtiny.git/tree/README

--%--
From: RokerHRO
Date: Fri, 02 Feb 2024 19:19:32 +0000

FLTK has its own minimal SVG library, which is already part of FLTK 1.3:
* https://github.com/fltk/nanosvg

For WebP I already plan a "clone" of the Fl_JPEG_Image class for WebP images. The library libwebp is small and easy to use: https://chromium.googlesource.com/webm/libwebp