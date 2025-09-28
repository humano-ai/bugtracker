Title: Prepare release 3.1.0-rc1
Author: rodarima
Created: Mon, 01 Apr 2024 21:40:14 +0000
State: closed

I need to decide some things before releasing 3.1.0, but at least all blockers are gone (for now).

- [x] Decide release signing key: 3EE6BA977EB2A253
- [x] Decide version scheme: 3.1.0 following Semver.
- [x] Decide which .zip/.tar.gz would be included and if we autogen the configure: Both tar.gz and zip, with `make dist-$fmt`
- [x] Decide if we want to make a release candidate first (probably good idea, at least for some weeks) or no. Yes.
- [x] Prepare release notes for the release page and also the website. The changelog is going to be gigantic, so we may want a summary.
- [x] Change version to 3.1.0-rc1 in configure.ac