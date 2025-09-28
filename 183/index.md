Title: Make headers self-contained
Author: rodarima
Created: Mon, 03 Jun 2024 19:24:31 +0000
State: open

In the current state of the implementation, headers are not self-contained. That is, when a header is included it may not include itself some other required headers, assuming the caller would have included it.

There shouldn't be any prior dependency on any other header, so they can be easily changed and moved around. This also helps identify dependencies among code.

This tool can help: https://include-what-you-use.org/

--%--
From: kalvdans
Date: Mon, 03 Jun 2024 20:42:14 +0000

It's a common practise for `foo.cc` to include `foo.hh` as its first include. That way, the compilation will test that the header is self-containing. Would you accept a pull request that changes all source files to include "their" header file first?