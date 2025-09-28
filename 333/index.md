Title: Add CMake build
Author: MoAlyousef
Created: Fri, 03 Jan 2025 08:46:37 +0000
State: open

Hello @rodarima 

This PR adds a CMake build to dillo. 
It by default uses FLTK 1.4. I tried getting FLTK 1.3 to work with CMake but unfortunately the distro-packaged FindFLTK.cmake or FLTKConfig.cmake are broken in some form for 1.3 on several systems like alpine, cygwin, freebsd and macos!
 
The CMakeLists.txt tries `find_package(FLTK 1.4 CONFIG)` and if it can't, it fetches the sources and builds FLTK. The CI actions do that, however when FLTK 1.4 is already installed, it finds it without issues. The PR also contains a `.github/workfows/cmake.yml`.
Once FLTK 1.4 is packaged for debian/ubuntu, I plan to modify the script and remove the FetchContent part.

There are many small commits which attempt to fix the CI, these can be squashed if you choose to merge the PR.


--%--
From: rodarima
Date: Mon, 06 Jan 2025 13:50:25 +0000

Thanks!, it looks good overall. I'll take a closer look when I find some
time. I think we can squash all commits into a single commit.

About FLTK 1.4, it is not working well just yet, so we will need to find a way
to make it find FLTK 1.3 in the meanwhile.

Have you had a chance to test cross-compilation? Is one of the reasons I wanted
to change the build system.


--%--
From: MoAlyousef
Date: Mon, 06 Jan 2025 16:41:08 +0000

Cross-compilation works, this jobs compiles from linxu x86-64 to aarch64:
https://github.com/MoAlyousef/dillo/actions/runs/12636324124/job/35208135068

Regarding FLTK 1.3, I think I can add a cmake script which manually tries to find the libraries since the FindFLTK.cmake that's distributed with CMake seems broken on some systems. Making cross-compilation work with that might be more difficult.

--%--
From: rodarima
Date: Mon, 06 Jan 2025 18:03:34 +0000

> Cross-compilation works, this jobs compiles from linxu x86-64 to aarch64:
> https://github.com/MoAlyousef/dillo/actions/runs/12636324124/job/35208135068

Thanks!, that's nice.

> Regarding FLTK 1.3, I think I can add a cmake script which manually tries to
> find the libraries since the FindFLTK.cmake that's distributed with CMake
> seems broken on some systems.

Here is the FindFLTK module: 

<https://gitlab.kitware.com/cmake/cmake/-/raw/master/Modules/FindFLTK.cmake>

In my current system (Arch Linux with FLTK 1.3.9) using:

    set(CMAKE_FIND_DEBUG_MODE TRUE)
    find_package(FLTK 1.3 REQUIRED)
    set(CMAKE_FIND_DEBUG_MODE FALSE)

It is also failing if I set the `FLTK_DIR` to the directory that contains the
FLTKConfig.cmake file with:

    CMake Error at /usr/share/cmake/Modules/FindFLTK.cmake:189 (load_cache):
      load_cache Cannot load cache file from /usr/share/fltk/CMakeCache.txt
    Call Stack (most recent call first):
      CMakeLists.txt:81 (find_package)

As it is trying to load the CMakeCache, but it is not distributed in the fltk
package. Not sure if this is Arch Linux fault or FLTK 1.3.9 forgot to install
it.

Not setting `FLTK_DIR` causes cmake to fail (also weird) when locating the
FindConfig.cmake file, which then fallbacks to using fltk-config and it works:

    -- Found FLTK: /usr/lib/libfltk_images.so;/usr/lib/libfltk_forms.so;/usr/lib/libfltk_gl.so;/usr/lib/libfltk.so (Required is at least version "1.3")

But there is no targets defined for FLTK 1.3 so using fltk::fltk fails. This
method will still fail when using cross compilation as fltk-config won't run.

Trying to locate the libraries by hand and making our own fltk::fltk target is
probably the best choice as it will also work well with cross-compilation, but
I'm not sure how to detect which other dependant libraries are also needed.


--%--
From: MoAlyousef
Date: Mon, 06 Jan 2025 19:18:30 +0000

I've replaced fltk::fltk with ${DILLO_FLTK_LIBS}  and used that across the modules. The build is green currently on all platforms. It still remains quite fragile. FLTK itself directs devs to use `find_package(FLTK CONFIG)`, however the packaged FLTK in distros is sometimes built using autoconf (like on macos, freebsd and cygwin for example), this makes the CONFIG value useless. 
This PR currently uses `find_package(FLTK REQUIRED)`, since even setting the version to 1.3 might not work!

The only job that uses FLTK 1.4 is the cross-compilation one. To use FLTK 1.4, devs would have to pass `-DENABLE_FLTK_1_4=ON` to cmake.


--%--
From: rodarima
Date: Sun, 12 Jan 2025 17:06:00 +0000

Thanks, I don't think we can rely on CONFIG as you comment. However, it would be nice to complain if FLTK is 1.4 (unless explicitly told so) as it will cause rendering issues even if it builds fine.

As long as we have a way to pass the installation path (libs and headers) of FLTK (avoiding fltk-config) I think that would be enough for cross-compilation.

Rebasing over a882875c324f9404351b1b9d3a095d7da4984ba9 will likely fix the CI.

--%--
From: MoAlyousef
Date: Sun, 12 Jan 2025 18:33:11 +0000

I've added a warning in the CMake script when targeting FLTK 1.4 (targeting of which already requires a feature flag ENABLE_FLTK_1_4). I've also squashed and rebased.

--%--
From: Kangie
Date: Thu, 30 Jan 2025 00:30:50 +0000

I still _highly_ recommend meson as the alternative bulid system when compared to CMake for maintainability, readability, (etc).  #263 is effectively complete, pending only a rebase. @rodarima will you consider that as an alternative?

I'm also happy to maintain it side-by-side with CMake if that is desirable, but either is better than Autotools.

--%--
From: Kangie
Date: Thu, 30 Jan 2025 05:20:59 +0000

As an aside, this CMake port seems to be done pretty well, my biggest gripe being that it's, well, CMake. My only feedback is that you need EOF newlines on most of the new files.

--%--
From: MoAlyousef
Date: Thu, 30 Jan 2025 09:03:53 +0000

I’m fine with either build generators. Both are cross-platform, can generate compile_commands.json (for extra tooling), and support cross-compilation. 