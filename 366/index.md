Title: Remove variadic macros
Author: Sunny-Maxis
Created: Fri, 14 Mar 2025 04:42:56 +0000
State: open

I understand this is a massive undertaking. However, there is a demand for such browsers on systems that do not run GCC. 

My boss, Kazuo Kuroi, got around this on libao (much smaller program) by converting the macros to static inlines:

https://codeberg.org/IRIXNet-Development/Nekoware-Package-Collections/src/branch/main/patches/neko_libao.patch

If it would be helpful I could probably attempt to stage something within the next month once we are finished with release testing our major projects

--%--
From: rodarima
Date: Wed, 19 Mar 2025 23:22:01 +0000

We could probably replace all of them, but it would be a major pain. Removing C++ macros is useful because then we could then lower the standard to C++04, but for C macros I don't think it would be very helpful apart for mipspro.

I would consider exploring this for C only if we find a big blocker that prevents using GCC.

--%--
From: Sunny-Maxis
Date: Thu, 20 Mar 2025 01:39:09 +0000

Hello Rodrigo,

GCC works fine with IRIX to an extent, but it has some annoyances:

1. fltk has to be recompiled from mipspro to GCC because GCC does not respect the sgi c++ ABI. We have tried and failed to fix this. 
2. GDB is fundamentally broken on the platform. Some people have managed to push back partial support but it isn't possible to do a lot of useful debugging.
3. For IRIX 6.5.21+, Kaz Kuroi and myself prefer to use mipspro because it:

- provides a functional and useful debugger
- doesn't require reduplication of libraries using the C++ abi. 
- more things are written with the intent of them being built by Mipspro 
- packaging for a mixed compiler setup is more complicated. We have to give GCC stuff its own root.
- is there something that a Variadic macro will provide that an inline variadic function will not? Functionally from my testing with libao Kazuo's fix didn't change anything about the library on a substantial level, errors and such still work as intended. 
- provides excellent and flexible optimization beyond what GCC offers. We can flag the compiler to not optimize certain functions, determine what types of optimizations should be applied with less verbosity needed (no need for -f/-m flags, these are literally colon separated lists we use for the compiler) shut off warnings easily etc. 
- for a lot of programs that might want to use system libraries such as libfam, libviewkit etc. there might not be alternatives to using Mipspro. 

--%--
From: rodarima
Date: Sun, 30 Mar 2025 20:13:12 +0000

I see. I won't oppose switching the variadic macros to functions, as long as we can make the compiler not emit any instruction when the debugging code is disabled (so we don't introduce any slowdown). However, I don't think I will prioritize this on my list of tasks, so you are welcome to provide a PR in this direction.

--%--
From: Sunny-Maxis
Date: Mon, 31 Mar 2025 01:08:25 +0000

I will talk to him about it and see if we can fork the repo at some point and make it happen. Thanks for being open to it. 