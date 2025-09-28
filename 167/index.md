Title: Enable IPv6 support by default
Author: suffieldacademy
Created: Sun, 12 May 2024 03:14:13 +0000
State: closed

This is a feature enhancement request.  I am using a device (macOS) that is IPv6-only, and testing Dillo as installed with homebrew.  Homebrew uses the default compilation options, which do not include IPv6 (`configure.ac` requires a flag to enable IPv6, and this is not on by default).

With IPv6 becoming more prevalent (and in Apple's case, mandatory), could you invert the configuration so that IPv6 is enabled by default, and can only be disabled by passing a flag?  That would prevent downstream package managers from having to add the flag to each of their build scripts.

If IPv6 support is not fully tested or ready for default deployment, then I completely understand and I can build my own manually with support enabled.

--%--
From: rodarima
Date: Sun, 12 May 2024 10:38:02 +0000

Yeah, this was in my long TODO list.

Ideally we should detect if IPv6 support is available on the system and enable it accordingly at configure time. Shouldn't be too hard to do.

Either way, we may want to allow users to disable IPv6 in the dillorc configuration at runtime, as it may cause connection delays while we fallback to IPv4 in some networks that don't support IPv6.

--%--
From: suffieldacademy
Date: Sun, 12 May 2024 21:21:40 +0000

Thank you; I'm sorry to dump more on but figured we could at least track it as an eventual TODO.  Great work on getting the new release out the door!

A runtime switch might be even better; we could have it on by default (or at least easily switchable without needing to rebuild).

Thanks!

--%--
From: Kangie
Date: Sat, 01 Jun 2024 00:44:11 +0000

> Ideally we should detect if IPv6 support is available on the system and enable it accordingly at configure time. Shouldn't be too hard to do.

Please don't implement this via configure automagic. IPv6 is one of those features that should just be turned on by default, relying on runtime logic to determine whether or not IPv6 is suitable.


--%--
From: rodarima
Date: Sat, 01 Jun 2024 09:38:38 +0000

> > Ideally we should detect if IPv6 support is available on the system and enable it accordingly at configure time. Shouldn't be too hard to do.
> 
> Please don't implement this via configure automagic. IPv6 is one of those features that should just be turned on by default, relying on runtime logic to determine whether or not IPv6 is suitable.

I don't mean to detect if IPv6 is enabled in the network if that is your worry.

By "available on the system" I mean if `struct sockaddr_in6` and `struct in6_addr` are defined by `<netinet/in.h>` and `<sys/socket.h>`, otherwise the build will fail. This is only regarding building support of IPv6 at *build time* and should also work if cross-compiling to a different machine.

At runtime, I plan on adding a switch in the dillorc configuration file, as sometimes it is required to turn off IPv6, even if it is available.

I need to do more testing to determine if we can switch it on by default at runtime (at build time there is no problem), as I remember this could cause an unexpected long delay on the DNS resolver until if fails back to IPv4, and novice users will have a hard time figuring out this is caused by IPv6.