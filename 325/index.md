Title: Fix build error for missing commit.h
Author: rodarima
Created: Tue, 17 Dec 2024 09:27:29 +0000
State: closed

Add the target commit.h as a dependency of version.o, so it gets
generated before being included in version.cc, otherwise when doing a
parallel build it can fail.
