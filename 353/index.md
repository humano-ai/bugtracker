Title: Compile without -std=c++11, not really needed
Author: pekdon
Created: Fri, 07 Feb 2025 17:49:44 +0000
State: closed

Might be a bit unconventional, downgrading the required standard, but without these extra , and the use of isinf this compiles and runs on Solaris 10 still which seems like a good fit for Dillo.

--%--
From: rodarima
Date: Fri, 07 Feb 2025 18:07:07 +0000

Thanks, the C++11 check is to prevent accidentally adding a dependency with newer standards.

We can run it only on the CI, as Dillo can be built with a compiler that supports C++03 and GNU macros, but I need to be sure it works first by making it fail.

> compiles and runs on Solaris 10 still which seems like a good fit for Dillo.

Screenshot for the gallery? https://dillo-browser.github.io/gallery/

--%--
From: pekdon
Date: Fri, 07 Feb 2025 18:44:51 +0000

Sounds reasonable to have such a check, easy to accidentally add!

Something like that?
![dillo_solaris10_cde](https://github.com/user-attachments/assets/ada28698-6ce0-4a32-b8ac-003c1684bdbc)

--%--
From: sevan
Date: Sat, 08 Feb 2025 23:10:27 +0000

This is great, and a huge timesaver. Alongside this patch I also had to make similar changes to 
`dw/fltkui.cc`, `src/css.hh`, `src/cssparser.cc`, `src/dillo.cc`, `src/html_common.hh`, `src/xembed.cc` and then I could build Dillo 3.2.0 on OS X 10.4 with GCC 4.0.1 on my PowerBook which takes just over 2 minutes. With a C++11 dependency add another 24 hours :)
[additional patch](https://github.com/user-attachments/files/18722511/dillo-patch-no-cpp11.txt)

Tested with GCC 4.0.1 & 8.5 on OS X 10.4 PowerPC.


--%--
From: pekdon
Date: Sun, 09 Feb 2025 11:43:57 +0000

Updated my branch based on your changes too @sevan (mentioned in the commit)

--%--
From: rodarima
Date: Tue, 18 Feb 2025 22:12:55 +0000

Thanks, these patches are great. It is nice to see it is still working on Solaris, I will the screenshot to the gallery :)

Before I merge this, I will add some commits to this PR to stick to C++11 only on the CI as well as some future features to be sure it fails.

--%--
From: sevan
Date: Tue, 18 Feb 2025 22:22:34 +0000

> Thanks, these patches are great. It is nice to see it is still working on Solaris, I will the screenshot to the gallery :)
> 
> Before I merge this, I will add some commits to this PR to stick to C++11 only on the CI as well as some future features to be sure it fails.

I guess there's a run which needs `-std=gnu++98` to be set since we're dealing with compilers which lack C++11 support?

--%--
From: rodarima
Date: Tue, 18 Feb 2025 22:38:39 +0000


> I guess there's a run which needs `-std=gnu++98` to be set since we're dealing with compilers which lack C++11 support?

It would probably be good add a CI build with an old GCC, as I don't know if gnu++98 is enough if you are building from a new compiler. For this PR I will just focus on not removing the current C++11 check.

Ideally we should remove the C++ variadic macros, which I believe is the only requeriment from C++11, so we can at least downgrade to C++03, but we can cover that in another issue/PR.