Title: Consider publishing Dillo to Flathub
Author: joshas
Created: Sat, 23 Nov 2024 20:21:51 +0000
State: closed

Please consider providing official Dillo package (flatpak) for [Flathub](https://flathub.org/). Main benefit is that single package can be used in many different Linux distributions. This could solve the problem with recent Dillo version not being available on Debian and other distributions, with exception of Ubuntu, as they prefer "snaps".
You can read about more benefits on [official website](https://docs.flathub.org/docs/for-app-authors/why-flathub). I understand, that there will be a lot of work to get package build and accepted to Flathub, but it is very important that flatpak package is provided by application author, not some random packager.
To help get you started, I have built a working [flatpak for current version of Dillo](https://github.com/joshas/dillo-flatpak/). It has strict permissions (no access to local files), and no way it should be considered of high quality. Would be great that someone with more knowledge about flatpaks would review the packaging configuration.

--%--
From: rodarima
Date: Sat, 23 Nov 2024 20:52:41 +0000

Sorry, but I will not maintain any binary package of Dillo, I'm already maintaining the software itself and that is plenty of work.

If you need to install it on any OS that doesn't have a package, I recommend you build it from source, which we have done a lot of work to be sure it works well. Building Dillo takes less than 10 minutes in the slowest machine I have, but typically 1 min.

I don't recommend you package something like a web browser that links with a TLS library with a mechanism that can prevent security updates from the repositories to reach Dillo. See https://flatkill.org/

The proper way is to unblock the Debian situation by having the current maintainer (or a trusted party) review our changes, which are not that many. This will also help the project itself, so is a win-win. The rest of distributions are up to date.