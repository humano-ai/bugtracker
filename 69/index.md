Title: Document the system requirements for users & developers/contributors
Author: RokerHRO
Created: Fri, 02 Feb 2024 19:47:40 +0000
State: open

As a user I'd like to know which platforms are currently supported / are planned to be supported in the near future.

As a developer I'd like to know which (minimalistic) platforms (CPU, OS version, compiler version, C++ language version, RAM usage) I have to consider when adding code or dependencies.



--%--
From: rodarima
Date: Fri, 02 Feb 2024 22:11:46 +0000

> As a user I'd like to know which platforms are currently supported / are planned to be supported in the near future.

Good point. I think we could divide the support into tiers or groups, as we currently cannot perform the same tests on architectures or platforms we don't have available (like Atari hardware) vs the ones on CI. As of now, we build Dillo on the GitHub CI for every PR on Ubuntu 22.04 and 20.04, macOS 13 and FreeBSD 14, but only in Ubuntu 22.04 we pass the rendering tests.

The rendering tests launch a full X server, open several pages in Dillo and compare the rendered outcome using an screenshot with a reference page. These tests are slow, so we also have to have that into mind, as we don't have infinite compute resources. Apart from that, the current set of tests is very limited, so we need to improve that before we could claim that we run on a system "properly".

I guess we could make at least three groups for a given platform:

1. Builds and pass the rendering tests in every merge in CI.
2. Builds only in CI
3. It should work and/or somebody claimed that it worked.

As of now, we would like to support most Linux based distributions, BSD and recent MacOS systems.

Regarding Windows, I saw some efforts with cygwin but I never tried as I don't own any Windows machine anymore. I wouldn't mind if someone makes the effort of making a pipeline in the CI to integrate it and we could try to maintain it working. As of now I would say is not supported, and I don't plan to add support for it in the near future.

> As a developer I'd like to know which (minimalistic) platforms (CPU, OS version, compiler version, C++ language version, RAM usage) I have to consider when adding code or dependencies.

You should try to avoid bringing more dependencies on Dillo as they are often not available in less common systems and make the browser more bloated. Sometimes this can be avoided by coding the features in external plugins that don't have these restrictions. If there is no other choice, placing the dependant code inside Dillo may be a better option, or making the feature optional.

Regarding the hardware, Dillo should be able to run reasonably well on any CPU of the last 20-30 years, but there are not explicit tests yet. It is posible to emulate an old system and see how it behaves, but I think we could find a metric like instructions per page rendered to measure and keep the performance monitored.

Dillo should be reasonably portable to systems that support POSIX and FLTK, so the specific OS version shouldn't matter much. Again, there are no tests for this, so we cannot enforce this.

The compiler should be fine with both gcc and clang, but it should support C++11 at least. We build Dillo in the CI with gcc and clang, but we don't test older versions.

The RAM usage is a bit tricky, as it scales with the page complexity. Additionally, Dillo caches pages in memory, which causes it to always increase the RSS. However, during an "average" session I would say I don't make it go above 100 MiB RSS. A metric that was used before is how much RAM is used (a factor) per MiB of HTML parsed. That number should be kept low.

I have in my TODO to add a CONTRIBUTING.md file.

--%--
From: RokerHRO
Date: Fri, 02 Feb 2024 22:50:18 +0000

@rodarima : Thanks for your quick answer! :-)

The reason why I ask is: If I'll to add some features the code will necessarily grow, and often there are CPU/memory tradeoffs for different implementations or algorithms etc. So I want to be able to check whether my code would kick out the old but still demanded platform X, compiler Y or increase resource Z to a higher limit L.

The discussion ran in the FLTK team too, 2 months ago: Shall the C-style code be changed to a more modern C++-style code, with contemporary C++ features (and allow C++14, C++17), which would ease development, simplify the code base (because C++ standard lib contains these features already), make it more platform independent, of course without losing maximal performance and minimal memory footprint.

Another singular example: I saw bugfixes for IRIX and non-C99-compliant compilers in the code. Are they still necessary?

--%--
From: rodarima
Date: Fri, 02 Feb 2024 23:22:46 +0000

> @rodarima : Thanks for your quick answer! :-)
> 
> The reason why I ask is: If I'll to add some features the code will necessarily grow, and often there are CPU/memory tradeoffs for different implementations or algorithms etc. So I want to be able to check whether my code would kick out the old but still demanded platform X, compiler Y or increase resource Z to a higher limit L.

I don't think I can provide a generic answer to this, but if you have an specific feature in mind that you would like to work on, I suggest you open an issue to discuss it (check first it is not already created), and then we can try to investigate if there is any conflict.

> The discussion ran in the FLTK team too, 2 months ago: Shall the C-style code be changed to a more modern C++-style code, with contemporary C++ features (and allow C++14, C++17), which would ease development, simplify the code base (because C++ standard lib contains these features already), make it more platform independent, of course without losing maximal performance and minimal memory footprint.

For now I would like to continue using C and C++11, until we can see more clearly the benefits of the change.

> Another singular example: I saw bugfixes for IRIX and non-C99-compliant compilers in the code. Are they still necessary?

If they don't annoy you, I would leave them as they are. Old thread: https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/thread/F3O6QUHJAK3HULV7TDA2PHU52RD3HSAY/#RCHNSBOXAUL5XN5QAVQJ2DEYMPH2LIT3