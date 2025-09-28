Title: Make Dillo strictly compliant with C90, C++11 and POSIX-2001
Author: rodarima
Created: Sun, 28 Jul 2024 14:41:56 +0000
State: closed

This PR changes the default flags in CFLAGS and CXXFLAGS to enable pedantic warnings and making Dillo strictly compliant with C90, C++11 and POSIX-2001.

Several non-portable code had to be modified to either use dlib functions or alternative portable functions.

Additionally, in the CI we enable `-Werror` so any pedantic warning makes the pipeline fail. It is important to allow other compilers to add pedantic warnings without breaking the build for users.

We can lower the C++11 to C++03 by getting rid of the macros, but it doesn't seem to be worth it for now.

Fixes #217 #218