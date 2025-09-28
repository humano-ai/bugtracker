Title: Performance regression tests
Author: rodarima
Created: Sun, 13 Apr 2025 19:20:10 +0000
State: open

As we do changes in Dillo, we risk introducing performance regressions that won't be detected unless we actually use Dillo on an old computer.

We could emulate an specific old CPU, but this would be much slower than just using the real hardware. What we probably want to keep in mind is that we need a crappy cache and low RAM.

I've been doing some experiments with a Raspberry Pi 2 B which has a BCM2836 chip with a ARM v7 CPU with float point unit and 1 GiB of RAM. So far it seems to be *very* good at being slow. I'm not able to find the CPU cache, nor it is available in lscpu, but it can be measured experimentally.

Ideally, we should be able to run the CI pipeline on the RPi directly, so we can detect regressions before merging. For now lets keep it simple, and I will just run the performance tests manually.

I could also use it to measure energy consumption in real time, so we can measure the CPU *and* the rest of the components while we benchmark the browser. The benefit of a RPi is that the power usage is minimal (1-4 W) so we won't waste resources.

To that end, we need some reference pages that exercise several parts of the browser pipeline and a signal that can stop the browser when the page has fully loaded. We need to be able to systematically render a page in about the same time. Having a specific device that doesn't do anything else can reduce the system noise so we can keep the measurements stable after several runs.



--%--
From: sevan
Date: Sun, 13 Apr 2025 22:56:00 +0000

The low end slow things aren't really offered as a hosted service so if it can be a procedure which folks can run & provide feedback that might give a better indication. Since dillo runs on OS X Tiger, I can test on G3 based machines.

Regarding the Pi, the 1st generation will provide an armv6 with 256 or 512MB RAM if I recall correctly. Let me know if you'd like a donation :)

--%--
From: rodarima
Date: Mon, 14 Apr 2025 17:45:39 +0000

> Since dillo runs on OS X Tiger, I can test on G3 based machines.

It would be handy if you report any issues you find while doing regular browsing, as I don't have any MacOS computers around to test (only the CI pipeline on GitHub). I would focus on one device for performance measurements for now, so we can start with a simple goal.

> Regarding the Pi, the 1st generation will provide an armv6 with 256 or 512MB RAM if I recall correctly. Let me know if you'd like a donation :)

Thanks for the offer, for now I think the RPi 2 B is in the sweet spot of being slow enough to be sensitive to performance issues and not too slow so we can run the tests reasonably fast. It also helps that I already had one around which I'm not using otherwise :)

--%--
From: sevan
Date: Mon, 14 Apr 2025 20:05:31 +0000

> > Since dillo runs on OS X Tiger, I can test on G3 based machines.
> 
> It would be handy if you report any issues you find while doing regular browsing, as I don't have any MacOS computers around to test (only the CI pipeline on GitHub). I would focus on one device for performance measurements for now, so we can start with a simple goal.

Sure, no worries, I'll help on the OS X / PowerPC testing side.
If you want to run the Intel build of Tiger and have virtualbox you can follow https://github.com/ranma42/TigerOnVBox/ though you should be able to run it on Qemu as well emulating powerpc or x86.
