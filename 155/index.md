Title: Update macOS install instructions
Author: yincrash
Created: Sun, 05 May 2024 18:02:47 +0000
State: closed

On macOS, Homebrew will install OpenSSL to different locations depending on which architecture you're on (Intel or ARM). It also doesn't put the headers and library files in the default search path for `gcc`.

This added instruction in the `doc/install.md` aligns with a similar instruction for BSD and is architecture and OpenSSL version agnostic (because it just asks Homebrew to tell us what the prefix is).

`pkg-config` could easily work across platforms or the lookup could be configured to test for homebrew, but I didn't want to make a much bigger change to the autoconf script.

--%--
From: yincrash
Date: Sun, 05 May 2024 21:14:12 +0000

Done