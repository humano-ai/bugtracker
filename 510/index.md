Title: Prepare release 3.3.0
Author: Rodrigo Arias Mallo
Created: Tue, 11 Nov 2025 19:02:04 +0100
State: closed

List of pending issues that block the next 3.3.0 release:

- ~~[Experimental build with FLTK 1.4.X](/509)~~
- ~~[Add a control socket](/383)~~
- ~~[Segmentation fault with display:none in form elements](/506)~~
- ~~[Wrong Max-Age parsing using local timezone](/521)~~

--%--
From: Rodrigo Arias Mallo
Date: Sun, 26 Apr 2026 17:43:38 +0200

With the FLTK 1.4.5 announcement, we have all the pieces ready for the 3.3.0
release. I did some tests and didn't saw any unexpected problems with the latest
FLTK release, so we can proceed.

Release checklist:

- [x] Make a new release branch.
- [x] Update ChangeLog with the release date and configure.ac version.
- [x] Make a commit and a signed tag and push it for the CI.
- [x] Build the dist tarball in .tar.gz.
- [x] Sign the tarball with my GPG key.
- [x] Make sure both the release and the GPG signature fit in a floppy
- [x] Install it from the tarball and make sure it works fine.
- [x] Copy the tarball to the website repo.
- [x] Prepare release notes and double check the download links work fine.
- [x] Sign the release page with my GPG key.
- [x] Leave the keyboard for at least 15 min (coffee?).
- [x] Double check again that it works fine.
- [x] Merge the release branch and push it to git (propagate to all mirrors).
- [x] Push the website with the release tarball and make sure it updates.
- [x] Publish the release on Fediverse, the mailing list and IRC.
- [x] Close this issue.
