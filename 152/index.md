Title: Provide prebuilt releases
Author: niutech
Created: Sun, 05 May 2024 09:43:09 +0000
State: closed

Please provide prebuilt binary releases for Linux/MacOS/Windows using existing CI by [storing artifacts](https://docs.github.com/en/actions/using-workflows/storing-workflow-data-as-artifacts) and uploading them to releases. Thanks!

--%--
From: rodarima
Date: Sun, 05 May 2024 11:27:54 +0000

Why?, what is wrong with building from source?

Providing binaries for all Linux/BSD distros and ensuring they work well would require a lot of work, which is often done by their maintainers. I'm not familiar with MacOS packaging, so I cannot comment on that one. For Windows you'll need Cywgin, so I don't think we can easily package an executable.

--%--
From: niutech
Date: Sun, 05 May 2024 21:32:17 +0000

Why? Because they are already being auto-built as CI by Github Actions, so the added cost is low and the entry threshold for users is significantly lower. For Windows, it's a matter of including *.dll files and for Linux it could be an AppImage.

--%--
From: rodarima
Date: Sun, 05 May 2024 22:15:55 +0000

> Why? Because they are already being auto-built as CI by Github Actions, so the added cost is low and the entry threshold for users is significantly lower. For Windows, it's a matter of including *.dll files and for Linux it could be an AppImage.

Sorry but I don't agree.

Dillo should be distributed via a package manager, the same you would install any other dependency. On MacOS you have Homebrew and on Windows you can add it to a Cygwin recipe. If you want to help, adopt it as a maintaner in any system you like. This way security fixes are propagated quickly without involving us and ABI change rebuilds are managed by the package maintainers.

In the case of a user that wants to try something that is not available as a package yet, I consider the entry point of downloading the source and executing the few commands to build and install Dillo an acceptable threshold.

Shiping TLS code in a AppImage bundle that never gets updates is a no-go.