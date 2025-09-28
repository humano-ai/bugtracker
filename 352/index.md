Title: meson as build system
Author: vtorri
Created: Fri, 07 Feb 2025 17:13:47 +0000
State: closed

i've looked at the slides at FOSDEM 25. It is said that slow compilation is a constraint.
I wouls suggest using meson instead of autotools, it's a LOT faster with a nice syntax
There is also a C port of meson (which is in python) called muon, which makes the compilation even faster.

in case it interests you

regards


--%--
From: rodarima
Date: Fri, 07 Feb 2025 17:24:53 +0000

Thanks, but the bootleneck in old computers is building the objects, not the build system. There are other reasons to move away from autotools though.