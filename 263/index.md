Title: Meson Build
Author: Kangie
Created: Tue, 01 Oct 2024 10:12:14 +0000
State: open

Hi Team,

While logging #262 I had the thought that it ought to be relatively straightforward to port Dillo to Meson.

I took a bit of time this afternoon and the result is an initial port.

It builds and links without complaint, but it's currently not producing a "working" dillo - I've missed something with DNS that I'll come back to shortly.

I know this wasn't specifically requested however I still think it's worthwhile:

- It's possible to run a 'meson' build using [`muon`](https://github.com/muon-build/muon) and [`samurai`](https://github.com/michaelforney/samurai) which are C99 implementations of Meson and Ninja respectively. 
- It's a lot smaller than automake + autoconf (coming in at just over half the lines of "code" to maintain, which could be reduced by adjusting the blind formatting rules I used)
- It's faster / more efficient
  + `sh -c 'meson setup --wipe build ; ninja -C build'  18.87s user 7.74s system 958% cpu 2.777 total`
  + `sh -c './configure && make -j'  33.55s user 4.55s system 550% cpu 6.917 total`
- It doesn't rely on `which` ;)

![image](https://github.com/user-attachments/assets/d28f7030-a01f-46b5-b2a6-008b59b3d096)

![image](https://github.com/user-attachments/assets/6032e622-f047-47e1-9cda-6d964a592d2d)

I'll keep plugging away at this unless you're not interested until we can get it ready for release.

Closes: #262 

Cheers,

Matt

--%--
From: rodarima
Date: Tue, 01 Oct 2024 17:03:28 +0000

Thanks for the PR and sorry for the late reply.

Even if I hate autotools with all my heart, they are capable of producing a unreadable but dependency-free configure script that can run in (almost?) any POSIX-compliant machine, including very old ones.

There are other issues with autotools too, which are mostly the reason I'll probably change the build system in the future, but I don't like the idea of adding python as a build dependency because of meson (or using the WIP muon).

As FLTK has switched recently to cmake, and it is very likely that it has to be supported in every platform that we want to build Dillo on, we can asume that cmake is already available due to indirect build dependencies. So I will be inclined to choose it over meson, which should yield similar speeds when using ninja instead of make.

In any case, I won't take this decision without making a study beforehand of the options, and see which one is more appropriate. Also consider the fact that I have already some knowledge on cmake, and almost none on meson. Regardless, this change will cause a major version bump, so it will not likely happen soon.

Regarding the `which` problem, it should be a ~5 line patch, so I don't think it is a reason to change the build system (yet). The IWYU patch is also welcome.

--%--
From: Kangie
Date: Tue, 01 Oct 2024 22:01:02 +0000

> or using the WIP muon.

Having recently done the fvwm3 meson port where Muon was a desired feature, I can say that the recent `0.3.0` release is effectively on-par with mainline Meson (so no hard Python req)

> As FLTK has switched recently to cmake, and it is very likely that it has to be supported in every platform that we want to build Dillo on, we can asume that cmake is already available due to indirect build dependencies. So I will be inclined to choose it over meson, which should yield similar speeds when using ninja instead of make.

CMake is "fine" however IMO Meson results in far more maintainable and readable build system code, and typically one obvious way to accomplish any given task rather than the ~5 ways that there are to do it in CMake (with no indication which is more appropriate for a given situation).

Which platforms that we're building C++11 code on don't support C99 and/or Python anyway ;)

With 99% of the porting done you shouldn't need to dig into the guts for quite a while.

I may submit a patch for the `which` issue at some point; got to do actual work today. I will, however, get the Meson build to the point that the browser is actually functional at some point so that you can compare.





--%--
From: rodarima
Date: Wed, 02 Oct 2024 05:31:40 +0000

> With 99% of the porting done you shouldn't need to dig into the guts for quite a while.

I need to understand very deeply the build system as to debug weird problems in all kinds of platforms I don't have access to, other than a mail/IRC channel with the person. So, totally the opposite.

> I may submit a patch for the `which` issue at some point; got to do actual work today.

Thanks, that would be nice.

--%--
From: Kangie
Date: Tue, 15 Oct 2024 00:08:35 +0000

Following up on this, it looks like it's (almost) all working:

![image](https://github.com/user-attachments/assets/047bea40-6422-4875-bc1c-29af4f06bca3)

```
build/src/dillo
paths: Cannot open file '/home/kangie/.dillo/dillorc': No such file or directory
paths: Cannot open file '/usr/local/etc/dillodillorc': No such file or directory
paths: Using internal defaults...
paths: Cannot open file '/home/kangie/.dillo/keysrc': No such file or directory
paths: Cannot open file '/usr/local/etc/dillokeysrc': No such file or directory
paths: Using internal defaults...
paths: Cannot open file '/home/kangie/.dillo/domainrc': No such file or directory
paths: Cannot open file '/usr/local/etc/dillodomainrc': No such file or directory
paths: Using internal defaults...
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.3.2 3 Sep 2024
Disabling cookies.
paths: Cannot open file '/home/kangie/.dillo/hsts_preload': No such file or directory
paths: Cannot open file '/usr/local/etc/dillohsts_preload': No such file or directory
paths: Using internal defaults...
Nav_open_url: new url='about:splash'
Nav_open_url: new url='https://www.google.com'
Dns_server [0]: www.google.com is 142.250.67.4 2404:6800:4006:811::2004
Connecting to 142.250.67.4:443
www.google.com: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 256-bit EC: /CN=www.google.com
sha256 2048-bit RSA: /C=US/O=Google Trust Services/CN=WR2
sha256 4096-bit RSA: /C=US/O=Google Trust Services LLC/CN=GTS Root R1
root: /C=BE/O=GlobalSign nv-sa/OU=Root CA/CN=GlobalSign Root CA
>>>> a_Nav_repush <<<<
Nav_open_url: new url='https://www.google.com'
a_Nav_expect_done: repush!
```

Not sure why the PNG isn't visible but that should be straightforward to fix, and the `etcdir` just needs a trailing slash.


--%--
From: Kangie
Date: Tue, 15 Oct 2024 00:21:50 +0000

OK, making progress... I had HAVE_PNG not ENABLE_PNG.

This is looking good:

![image](https://github.com/user-attachments/assets/6ec8dfa6-1969-4296-afc4-657d5ab23554)

```
aths: Cannot open file '/home/kangie/.dillo/dillorc': No such file or directory
paths: Cannot open file '/usr/local/etc/dillo/dillorc': No such file or directory
paths: Using internal defaults...
paths: Cannot open file '/home/kangie/.dillo/keysrc': No such file or directory
paths: Cannot open file '/usr/local/etc/dillo/keysrc': No such file or directory
paths: Using internal defaults...
paths: Cannot open file '/home/kangie/.dillo/domainrc': No such file or directory
paths: Cannot open file '/usr/local/etc/dillo/domainrc': No such file or directory
paths: Using internal defaults...
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.3.2 3 Sep 2024
Disabling cookies.
paths: Cannot open file '/home/kangie/.dillo/hsts_preload': No such file or directory
paths: Cannot open file '/usr/local/etc/dillo/hsts_preload': No such file or directory
paths: Using internal defaults...
Nav_open_url: new url='about:splash'
Nav_open_url: new url='http://www.google.com'
Dns_server [0]: www.google.com is 142.251.221.68 2404:6800:4006:809::2004
Connecting to 142.251.221.68:80
>>>> a_Nav_repush <<<<
Nav_open_url: new url='http://www.google.com'
a_Nav_expect_done: repush!
```

--%--
From: Kangie
Date: Tue, 15 Oct 2024 00:26:05 +0000

Sorry about the spam, but best to keep this commentary separate:

> Regardless, this change will cause a major version bump, so it will not likely happen soon.

There's little reason (aside from keeping autotools in the repo...) not to include the meson build files alongside autotools for a transitional period, then you are able to deprecate autotools and remove it at a time of your choosing with the confidence that it's not going to suddenly cause downstream issues.

--%--
From: Kangie
Date: Tue, 15 Oct 2024 22:52:14 +0000

@rodarima 

Thoughts? I'm having a bit of trouble with the HTML tests in CI  (frankly I can barely get them to run on Gentoo at the best of times) but otherwise we have a working browser and test suite.

~Cygwin is unfortunate, but it was building and passing tests before I set the required meson version to _just_ above what is currenly packaged. Theoretically pip will work, just pushed that change; can follow up and request a slightly newer meson be packaged.~

--%--
From: rodarima
Date: Wed, 16 Oct 2024 17:16:00 +0000

I'm not sure what problem you are trying to solve here, but I see you are putting a lot of effort into something we have not requested or encouraged. There are plenty of issues here that I would like someone to help with: https://github.com/dillo-browser/dillo/issues

Autoconf/autotools is doing an acceptable job as build system. It is slow but that shouldn't be a big problem when Dillo is mainly targeted towards slow machines where the bottleneck is the build (not the scheduling of the build). Saving some seconds in the build process is not very relevant when we can produce a portable tarball release.

I have a limited time to spend on the project, so I will prioritize not changing the build system or choosing one that I'm familiar with, rather than learning a new one. I will not maintain two build systems, when we switch (if we do) we will remove autotools.

Keep in mind that we can only test a very limited amount of (modern) platforms right now, and I will not try to switch the build system until I have determined which platforms we decide to break and which ones to continue to support. Before that point, I would like to have improved the CI so we also test Dillo on older hardware. Until that happens, I will not change the build system.

I think this PR may be useful to compare with cmake or others in the future (I have saved the patch), but from the knowledge I have right now it is very unlikely that we end up switching to meson/muon.

Fixes for includes would be nice to merge on their own.

I know there are current problems with the current build system. For example, we don't support cross-compilation, mainly by the way we query FLTK and other flags, but that can also be fixed independetly without changing the build system.

> I'm having a bit of trouble with the HTML tests in CI (frankly I can barely get them to run on Gentoo at the best of times)

The HTML test suite is not designed to run by non-developers, the same way I don't expect you to pass the WPT tests when packaging Firefox or Chromium. But essentially, we open the test page on dillo in a virtual X server and take a snapshot, then we do the same with a reference page and we compare the pixels one by one. The two images are saved, so you may be able to see what went wrong. Also, those tests require a vanilla dillorc and style.css, otherwise you will likely break them. If they continue to break, please address it in a new issue, as they shouldn't break.

--%--
From: Kangie
Date: Wed, 16 Oct 2024 23:06:57 +0000

> but I see you are putting a lot of effort into something we have not requested or encouraged

Making the world a better place is its own reward.

Additionally, as a downstream packager/maintainer it ended up being more effective to _rewrite the whole build system_ than deal with the mess that is the existing autotools impl. I also really don't want to deal with more downstream tickets or additional porting work due to the (at best, charitably described as) legacy way in which the current Autotools implementation does things.

> There are plenty of issues here that I would like someone to help with: https://github.com/dillo-browser/dillo/issues

I would be more inclined to help if I didn't have to deal with a poor autotools impl, and I'm not inclined to fix autotools when the work on meson is _already done_.

> so I will prioritize not changing the build system or choosing one that I'm familiar with, rather than learning a new one. I will not maintain two build systems, when we switch (if we do) we will remove autotools.

As the current maintainer of Dillo, that's your prerogative. I can point at other examples where projects aimed at low spec / older machines and which value portability have gone with precisely this approach, and picked Meson.

> I will not try to switch the build system until I have determined which platforms we decide to break and which ones to continue to support

As a C++ project you can assume that C99 compilers will be available to provide `muon` and `samurai` to substitute for `meson` and `ninja` respectively on platforms that don't have (or want) a Python dependency.

If your platforms need C++11 and don't support C99 that is, honestly, their problem. Users can always continue to use an older tarball - who actually updates these legacy systems you're concerned about frequently, and isn't likely to just grab an older tarball?

> I know there are current problems with the current build system. For example, we don't support cross-compilation, mainly by the way we query FLTK and other flags, but that can also be fixed independetly without changing the build system.

The TL;DR is that I've already done _all of the work for you_ on each of the issues that you've just listed.

If you want to throw that away because you already have "some knowledge" of cmake that is, of course, your choice.

Having already admitted that you already have limited time to work on this project, and with volunteers submitting fixes for deficiencies in the existing build system that you are aware of, it really seems like you're shooting yourself in the foot by not considering this.

> Saving some seconds in the build process is not very relevant when we can produce a portable tarball release.

Saving time in CI/downstream delivers on measurable benefits to both energy consumption and to the people that have to actually verify their own bulids.

Additionally the reduced complexity of Meson (and the use of a matrix to provide better CI/CD coverage in a concise manner) lends itself to a more maintainable build system going forward. How many autotools issues have not been fixed because it's terrible spaghetti that's too hard to parse?

> Fixes for includes would be nice to merge on their own.

`git cherry-pick ...`

> The HTML test suite is not designed to run by non-developers

Conveniently I, as a downstream packager, _do_ want to know that my package behaves as expected before pushing it out to my users.

> If they continue to break, please address it in a new issue, as they shouldn't break.

I'm really not inclined to touch anything to do with autotools in _my_ limited time for this project.

--%--
From: rodarima
Date: Thu, 17 Oct 2024 17:57:09 +0000

> The TL;DR is that I've already done all of the work for you on each of the issues that you've just listed.

This is far from the reality.

You have done a fair amount of work to help yourself avoid dealing with autotools (which is understandable) but you have not really considered the implications of this change for the project and other users.

The expensive part of the work is not porting this to a new build system, but maintaining it over the years and identifying issues reported by users from other platforms I don't have access to.

You have continued to work on this on your own, even if I have already explained to you that I will evaluate this in the future not now. I cannot stop you from spending your own time into whatever it is you what to spend it.

Your current solution continues to rely on the `fltk-config` binary, which won't work for cross compilation, which is one of the main issues I want to solve when switching the build system. I prioritized cmake because they can read the information from the .cmake module of FLTK directly:

https://cmake.org/cmake/help/latest/module/FindFLTK.html
https://github.com/Kitware/CMake/blob/fa61269d8e6e75448437cf9071cde97ecb35e054/Modules/FindFLTK.cmake#L163-L207

> If you want to throw that away because you already have "some knowledge" of cmake that is, of course, your choice.

> As the current maintainer of Dillo, that's your prerogative

> git cherry-pick ...

The hostile behavior is not helping. I suggest you consider how you what to approach the FOSS comunity.

> Conveniently I, as a downstream packager, do want to know that my package behaves as expected before pushing it out to my users.

And I, as the person who wrote the test infrastructure as well as those tests, I'm telling you that they are not designed for you to run as packager. They are designed to avoid introducing regressions in the layout engine. Same with RTFL, which I have no idea why you enabled it under the "debug" flag.

If you still insist into running them, I recommend you read the output logs to see what is wrong rather than blaming autotools:

https://933451.bugs.gentoo.org/attachment.cgi?id=894972

```
+ xwd -id 0x200009 -silent
+ convert xwd:- png:white-space.html_x8y/html.png
client(400000): Reserved pid(931).
client(400000): Reserved cmdname(xwd) and cmdargs(-id 0x200009 -silent).
AllocNewConnection: client index = 2, socket fd = 8, local = 1
convert: unable to open image 'xwd:-': No such file or directory @ error/blob.c/OpenBlob/3571.
```

Your convert(1) program doesn't understand `xwd:-` for some reason. We may be able to place it in a temporary directory instead of using a pipe, not sure what is causing this problem on your end (maybe a config switch on convert).

I really don't have any interest in pursuing this discussion futher, as I want to focus on the next 3.2.0 release. I understand your position, and I will come back to reevaluate this in the future, hopefully when we have some more exotic machines to test a build system on.

--%--
From: Kangie
Date: Fri, 18 Oct 2024 01:34:56 +0000

> You have continued to work on this on your own, even if I have already explained to you that I will evaluate this in the future not now

You need a working (or mostly-working) PR to evaluate; the initial state was 'it builds'. The current PR is mostly feature-complete, however obviously the HTML tests aren't running properly in CI (likely down to how the script is invoked via meson), and some of the more debug-y options are not yet implemented (`efence`, `gprof`, `insure`) - That should be enough for you to decide whether or not you want to proceed further down this path.

**edit**: HTML tests actually appear to be working locally, but never returning properly - the test output appears to show expected tests and failures but Meson's test harness isn't happy and if the timeout is disabled the tests "run" indefinitely - I'll look into the test script at some point, maybe.

**Edit 2**: First HTML test terminated successfully without intervention in just over an hour so they will eventually complete.

**Edit 3**: After remembering to install Dillo into a prefix I'm able to successfully run the HTML rendering tests via meson (using the binary in `builddir/src`)  locally. Oops.  I suspect that the missing files may have been the cause of the hanging tests. There are a number that now actually fail based on the image comparison; I'll look into the html - I didn't have everything enabled in terms of image formats and that's a likely culprit.

> Your current solution continues to rely on the `fltk-config` binary, which won't work for cross compilation, which is one of the main issues I want to solve when switching the build system. I prioritized cmake because they can read the information from the .cmake module of FLTK directly:
> 
> https://cmake.org/cmake/help/latest/module/FindFLTK.html https://github.com/Kitware/CMake/blob/fa61269d8e6e75448437cf9071cde97ecb35e054/Modules/FindFLTK.cmake#L163-L207

Thanks for the pointer, I'd assumed that was coming with upstream's port to CMake that you mentioned; I've pushed a commit that will use this to detect FLTK (which I'll rebase and squash at some point soon); turns out it needed `FLTK` not `fltk`. I suspect that it's going to fall back to `fltk-config` a lot of the time anyway; upstream probably still need to ship a pkgconfig file. This will likely be true regardless of build system.

> > If you want to throw that away because you already have "some knowledge" of cmake that is, of course, your choice.
> 
> > As the current maintainer of Dillo, that's your prerogative
> 
> > git cherry-pick ...
> 
> The hostile behavior is not helping. I suggest you consider how you what to approach the FOSS comunity.

I'm sorry that you feel that this is hostile, there has been some miscommunication; It's your project, it's your choice whether or not you accept offered help - I'm not going to be bitter if you go with CMake (though if you hit the '5 ways to do something with no obvious best option' I may drop-in for an 'I told you so').

On my part I'm a bit of a build system buff who has worked on / ported multiple projects, and I have seen many poor CMake implementations in-the-wild: I regularly work on Autotools, CMake, GN, Meson, and hand-rolled scientific computing Makefiles.

I'm also involved in upstream fixes to many packages that I maintain; I'd consider your examples to be 'direct' or 'blunt' communication but I'll take it under consideration.

I'm not likely to submit additional PRs for the trivial fixes, please feel free to cherry pick them; I'll sort out any conflicts when I rebase.

As a real carrot for a proper build system, tools like [`include-what-you-use`](https://github.com/include-what-you-use/include-what-you-use) will make identifying future instances of this trivial and comes "free" with CMake or Meson.

> Same with RTFL, which I have no idea why you enabled it under the "debug" flag.

This:

https://github.com/dillo-browser/dillo/blob/572b9346d5d844822b1a0cc1f22e15fb898135b4/configure.ac#L74-L75

`debug` seems more appropriate than `rtfl` based on the comment, and enabling `-Ddebug` seems like something no reasonable person would use in anger in the real-world. When it comes time to evaluate, and if you decide to proceed, please ping me with any desired changes, this is a first-pass 'port autotools effectively as-is', not a final state.

> Your convert(1) program doesn't understand `xwd:-` for some reason. We may be able to place it in a temporary directory instead of using a pipe, not sure what is causing this problem on your end (maybe a config switch on convert).

Appreciate the pointer; I've pushed a commit to include the missing X11 dependencies on ImageMagick.

>  I want to focus on the next 3.2.0 release. I understand your position, and I will come back to reevaluate this in the future, hopefully when we have some more exotic machines to test a build system on.

Evaluate at your leisure, please don't think I was implying that this should replace the build system for your upcoming release. As downstream packager I would _love_ to see any replacement for Autotools considered at some point after that.

As a final note I would like you to consider running Autotools and Meson (or CMake) side-by-side for a transition period - we can add a `-Dexperimental` flag a la `freeciv` to indicate to users that it's not the 'default' build path (and make them explicitly opt-in) and we can roadmap the deprecation - this should enable users with those exotic systems to provide feedback well before the legacy build is in any danger of being removed. The updated matrix CI should make maintaining them side-by-side far easier :)

--%--
From: Kangie
Date: Thu, 30 Jan 2025 02:30:25 +0000

Rebased on current master, tidied up commit history and squashed meson commits down for comparison with #333 

Builds fine, runs fine. Tests are running successfully but timing out - I can dig into that if further development is welcome. CI updated to use matrices to test as many options as possible, but not tested post merge; I expect failures here.

I suspect the remaining issues to be tidied up are to do meson not successfully interpreting the test driver exiting, as my test logs show the diff coming back as `0 = 0`.

```
==================================== 9/44 ====================================
test:         b-div
start time:   02:13:40
duration:     30.00s
result:       exit status 0
command:      MESON_TEST_ITERATION=1 MSAN_OPTIONS=halt_on_error=1:abort_on_error=1:print_summary=1:print_stacktrace=1 MALLOC_PERTURB_=126 UBSAN_OPTIONS=halt_on_error=1:abort_on_error=1:print_summary=1:print_stacktrace=1 ASAN_OPTIONS=halt_on_error=1:abort_on_error=1:print_summary=1 DILLOBIN=/data/development/temp/dillo/build/src/dillo /data/development/temp/dillo/test/html/driver.sh /data/development/temp/dillo/test/html/render/b-div.html
----------------------------------- stdout -----------------------------------
paths: Cannot open file '/home/kangie/.dillo/dillorc': No such file or directory
paths: Cannot open file '/tmp/dillo/etc/dillo/dillorc': No such file or directory
paths: Using internal defaults...
paths: Cannot open file '/home/kangie/.dillo/keysrc': No such file or directory
paths: Cannot open file '/tmp/dillo/etc/dillo/keysrc': No such file or directory
paths: Using internal defaults...
paths: Cannot open file '/home/kangie/.dillo/domainrc': No such file or directory
paths: Cannot open file '/tmp/dillo/etc/dillo/domainrc': No such file or directory
paths: Using internal defaults...
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.3.2 3 Sep 2024
Disabling cookies.
paths: Cannot open file '/home/kangie/.dillo/hsts_preload': No such file or directory
paths: Cannot open file '/tmp/dillo/etc/dillo/hsts_preload': No such file or directory
paths: Using internal defaults...
Nav_open_url: new url='file:/data/development/temp/dillo/test/html/render/b-div.html'
** ERROR **: [Dpi_read_comm_keys] No such file or directory
Dpi_blocking_start_dpid: try 1
paths: Cannot open file '/home/kangie/.dillo/dillorc': No such file or directory
paths: Cannot open file '/tmp/dillo/etc/dillo/dillorc': No such file or directory
paths: Using internal defaults...
paths: Cannot open file '/home/kangie/.dillo/keysrc': No such file or directory
paths: Cannot open file '/tmp/dillo/etc/dillo/keysrc': No such file or directory
paths: Using internal defaults...
paths: Cannot open file '/home/kangie/.dillo/domainrc': No such file or directory
paths: Cannot open file '/tmp/dillo/etc/dillo/domainrc': No such file or directory
paths: Using internal defaults...
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.3.2 3 Sep 2024
Disabling cookies.
paths: Cannot open file '/home/kangie/.dillo/hsts_preload': No such file or directory
paths: Cannot open file '/tmp/dillo/etc/dillo/hsts_preload': No such file or directory
paths: Using internal defaults...
Nav_open_url: new url='file:/data/development/temp/dillo/test/html/render/b-div.ref.html'
OK
----------------------------------- stderr -----------------------------------
+ DILLOBIN=/data/development/temp/dillo/build/src/dillo
+ '[' '!' -e /data/development/temp/dillo/build/src/dillo ']'
+ magick_bin=convert
+ command -v magick
+ magick_bin=magick
+ test_file /data/development/temp/dillo/test/html/render/b-div.html
+ html_file=/data/development/temp/dillo/test/html/render/b-div.html
+ '[' '!' -e /data/development/temp/dillo/test/html/render/b-div.html ']'
+ ref_file=/data/development/temp/dillo/test/html/render/b-div.ref.html
+ '[' '!' -e /data/development/temp/dillo/test/html/render/b-div.ref.html ']'
++ basename /data/development/temp/dillo/test/html/render/b-div.html
+ test_name=b-div.html
+ wdir=b-div.html_wdir
+ rm -rf b-div.html_wdir
+ mkdir -p b-div.html_wdir
+ mkfifo b-div.html_wdir/display.fifo
+ exec
+ xorgpid=999693
+ trap 'kill 999693' EXIT
+ read dispnum
+ Xvfb -screen 5 1024x768x24 -displayfd 6
_XSERVTransSocketUNIXCreateListener: ...SocketCreateListener() failed
_XSERVTransMakeAllCOTSServerListeners: server already running
_XSERVTransSocketUNIXCreateListener: ...SocketCreateListener() failed
_XSERVTransMakeAllCOTSServerListeners: server already running
+ export DISPLAY=:2
+ DISPLAY=:2
+ render_page /data/development/temp/dillo/test/html/render/b-div.html b-div.html_wdir/html.png
+ htmlfile=/data/development/temp/dillo/test/html/render/b-div.html
+ outpic=b-div.html_wdir/html.png
+ dillopid=999706
+ sleep 1
+ /data/development/temp/dillo/build/src/dillo -f /data/development/temp/dillo/test/html/render/b-div.html
++ xwininfo -all -root
++ awk '/Dillo:/ {print $1}'
+ winid=0x200009
+ '[' -z 0x200009 ']'
+ xwd -id 0x200009 -silent
+ magick xwd:- png:b-div.html_wdir/html.png
+ kill 999706
+ render_page /data/development/temp/dillo/test/html/render/b-div.ref.html b-div.html_wdir/ref.png
+ htmlfile=/data/development/temp/dillo/test/html/render/b-div.ref.html
+ outpic=b-div.html_wdir/ref.png
+ dillopid=999771
+ sleep 1
+ /data/development/temp/dillo/build/src/dillo -f /data/development/temp/dillo/test/html/render/b-div.ref.html
++ xwininfo -all -root
++ awk '/Dillo:/ {print $1}'
+ winid=0x200009
+ '[' -z 0x200009 ']'
+ xwd -id 0x200009 -silent
+ magick xwd:- png:b-div.html_wdir/ref.png
+ kill 999771
++ compare -metric AE b-div.html_wdir/html.png b-div.html_wdir/ref.png b-div.html_wdir/diff.png
+ diffcount=0
+ '[' 0 = 0 ']'
+ echo OK
+ ret=0
+ exec
+ rm b-div.html_wdir/display.fifo
+ '[' -z '' ']'
+ rm -rf b-div.html_wdir
+ return 0
+ exit 0
+ kill 999693
==============================================================================
```

--%--
From: Kangie
Date: Thu, 30 Jan 2025 02:31:04 +0000

It's probably worth, at the very least, cherry-picking the IWYU fixes.

--%--
From: Kangie
Date: Thu, 30 Jan 2025 04:27:03 +0000

Tracked down hanging tests to the exit trap.

If there's willingness to consider merging this I'm happy to tidy up the CI and look into test failures, but otherwise the port is "done", and is up-to-date with current master.

--%--
From: Sunny-Maxis
Date: Sat, 01 Mar 2025 21:23:06 +0000

Comment for Rodrigo:

Do not adopt meson if you plan to support old UNIXes. Muon, the C99 Meson, is unfortunately poorly coded with poor support for aligned access on RISC systems and numerous problems (My main critique being, who peppers a setup with hundreds of asserts in a DEFAULT BUILD?), and boson, the C11 version, is poorly maintained. 

Out of all options, autotools is preferable, but CMake is workable. I understand as you are moving to C++11 that GCC moreorless will become the sole compiler, but dillo never properly built on anything else. 

I do not want to hurt Kengie's feelings or upset their effort, it's just, Meson is not an acceptable system for this project. CMake has additionally decent Windows support, if MS windows support is a priority. 

--%--
From: eli-schwartz
Date: Sun, 02 Mar 2025 02:25:34 +0000

I hope you don't plan on compiling CMake on systems without a C++ (11) compiler.

--%--
From: Sunny-Maxis
Date: Sun, 02 Mar 2025 05:24:37 +0000

> I hope you don't plan on compiling CMake on systems without a C++ (11) compiler.

Building a build tool with GCC is different than building a program with a native compiler. 

There's hassles and problems with building GCC for everything on niche platforms. On IRIX, for instance, GCC cannot be effectively debugged even with restored GCC support from Kazuo K. or the SGUG GCC, the gdb system on IRIX can't debug threads, stack traces are funky. dbx expects dwarf of a certain kind. On Itanium and PA-RISC, GCC's C++ performance compared to HPE's is baaad. It's a bit better there, you got several compilers to choose from depending on OS (ICC, aCC, Pro64) but yeah, I think ya get my point. 

Regardless, I was offering my input. Dillo is a useful browser and you gotta get with the times, Cmake being a necessity is what it is. Meson and Muon are not acceptable IMHO for projects that target older systems. 

--%--
From: rodarima
Date: Sun, 02 Mar 2025 13:55:29 +0000

> Meson and Muon are not acceptable IMHO for projects that target older systems.

I also suspect the same, but I will need to do more research to be sure. This is not a priority now, so I will take some time to address other issues first. I recommend not investing more time in this PR until that is clarified on my side, otherwise you risk wasting your time.

> I hope you don't plan on compiling CMake on systems without a C++ (11) compiler.

We try to target 20+ year old stacks, including older gcc with no support for C++11 as we only need variadic macros from C++11 which are available in much older compilers. There is no public announcement about what we support and what not because is not an easy task to even measure (I don't have access to many of the old systems that claim to run Dillo).

I won't change the build system until I have researched all platforms in which Dillo works currently and how it will be affected. And I would rather not maintain two build systems.

If you @Sunny-Maxis want to help improving the support on IRIX that would be nice to have. Feel free to open another issue to track the current status and what we can do to improve it.

--%--
From: eli-schwartz
Date: Sun, 02 Mar 2025 16:28:32 +0000

> We try to target 20+ year old stacks, including older gcc with no support for C++11 as we only need variadic macros from C++11 which are available in much older compilers. There is no public announcement about what we support and what not because is not an easy task to even measure (I don't have access to many of the old systems that claim to run Dillo).

CMake, when compiling itself, searches for a C++17 compiler, or a C++14 compiler, or a C++11 compiler, and if it cannot at least find a C++11 compiler it errors out with this code:

```cmake
  if(NOT CMake_HAVE_CXX_UNIQUE_PTR)
    message(FATAL_ERROR "The C++ compiler does not support C++11 (e.g. std::unique_ptr).")
  endif()
```

So I don't think you can use cmake if you target 20+ year old stacks.

Meson can in theory run on any system with a c99 compiler, though it may require either:
- python (the entire programming language -- python 3.10 is written in c99, python 3.11 moved to c11, meson supports python 3.7)
- or muon (a relatively lean codebase implementing a standalone version of meson in c99)

to be ported to that system, possibly a much easier task than porting a C++ compiler.

According to https://github.com/muon-build/muon/issues/115

> Muon would benefit IRIX because Python is terrible on our platform for speed and performance.

which indicates that python does *work*?

Muon is definitely willing to accept patches, but it was made clear that IRIX in particular cannot be emulated, and uses a different MIPS ABI than other OSes running on MIPS, and @Sunny-Maxis decided it was too painful to debug (interesting assessment) so idk what to tell you. I am not convinced that experience is generally applicable to older systems.

I suppose you could argue that the only option is to continue with autotools...

--%--
From: rodarima
Date: Sun, 02 Mar 2025 19:08:38 +0000

> I suppose you could argue that the only option is to continue with autotools...

For very old platforms it probably is the best tradeoff for now, but it slows down development on relatively modern ones. However the current issues I have with autotools are probably fixable with enough perseverance.

--%--
From: Sunny-Maxis
Date: Mon, 03 Mar 2025 07:08:06 +0000

> If you @Sunny-Maxis want to help improving the support on IRIX that would be nice to have. Feel free to open another issue to track the current status and what we can do to improve it.

I will definitely give it a shot when I'm at that point. It's going to be a hot minute more than likely because we are trying to get other stuff out of the way. 


> So I don't think you can use cmake if you target 20+ year old stacks.

This is a fair assessment. However I can get a version of Cmake running on IRIX (3.8 or so) using a somewhat recent version of GCC without dealing with libuv, and people have gotten a later version of it running using their own tool chains. 

That is to say he could simply stick with an older version of Cmake as a minimum required version. 

> which indicates that python does _work_?
Python does work but Meson presumably will continue to roll forward with more and more stringent system requirements that spells bad news for such a project where you're trying to maintain support for obsolete platforms. 

It's extremely painful to use meson on a system like IRIX. Unless you're cross compiling which I am not able to do with our setup because we are trying to use the native compiler whenever possible, and because my boss is of the opinion that cross compiling is not necessary on this particular system. 
> Muon is definitely willing to accept patches, but it was made clear that IRIX in particular cannot be emulated, and uses a different MIPS ABI than other OSes running on MIPS, and @Sunny-Maxis decided it was too painful to debug (interesting assessment) so idk what to tell you. I am not convinced that experience is generally applicable to older systems.

This is somewhat out of the scope for this discussion but I will briefly elaborate:

1. It was crashing no matter which compiler are used even before initialization. Manually disabling the asserts that were used in the code in the range of almost 200 was possible to get it further but it ended up failing  well before it actually did anything useful. Asserts are a great tool for debugging but I was repeatedly informed throughout the thread that removing them was not supported / they kept on telling me I was doing it wrong which I didn't appreciate. That was severely condescending. 


2. They couldn't answer basic aligned access questions which I suspected was the ultimate issue because you would once you got past the assert bull end up with bus errors which usually means stack alignment issues. 

3. They kept on insisting it was a problem with the compiler which was complete bull crap. We have compiled dozens of programs without problems using both compilers and it was just not productive use of our time anymore. 

4. For the most part when something requires meson/ninja we just use an older release or in some cases my boss has ported applications to new build systems and given the finger to the person who thought it was an educated idea to lock out older systems on a relatively portable application otherwise. 

> I suppose you could argue that the only option is to continue with autotools...

This is what I would recommend based on what's being said here. If you're going to Target windows as a platform at all honestly you should just tell people that they should have to fork and track the project separately with Ms build or something. The windows and UNIX universes are just not compatible on several levels. 

Regardless it's much easier to port GCC to a platform or reinstate support even, then to sometimes deal with poor upstream support or crap code. Sometimes dealing with projects like Muon, which I'm not saying was intentional on their part, feels like pulling teeth and I don't appreciate the way I was lectured on several occasions and told to just throw printf's everywhere. 

Rodrigo you'll be hearing from me when I do have something to show on dillo for IRIX. That'll probably be sometime in the next 3 to 4 months or so. That may not be that far off though that's just a rough estimate. 