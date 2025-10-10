Title: Setup self-hosted CI runner
Author: Rodrigo Arias Mallo
Created: Tue, 30 Sep 2025 20:08:02 +0200
State: open

While moving the git repo away from GitHub (see #500) was relatively easy, now
we need to still do the heavy lifting of setting up a CI pipeline that we can
run ourselves.

We will also need to define which platforms we will continue to test on the CI.
So far we can setup:

- Linux: Alpine on ARM v7, Arch Linux and Debian on x86
- BSDs: For now VM.

Dropped from GitHub Actions:

- Windows via Cygwin
- Mac OS
