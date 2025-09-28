Title: Move test suite to another repository
Author: rodarima
Created: Tue, 20 Aug 2024 12:18:30 +0000
State: open

Our current test suite involves a very limited number of simple HTML rendering
tests. These tests are currently distributed in the tarball release.

However, there are other tests we should be doing which would involve many other
pieces that we don't use for Dillo:

- HTTP, HTTPS, FTP, Gopher, Gemini, and other servers
- Multiple TLS ciphers (including broken ciphers or bad behaved replies)
- Multiple compression algorithms for transfer encoding
- Multiple content type mismatch (Content-Type says PNG, image bytes say JPG)
- Very slow networks and missing packets (TLS timeout?)
- Performance tests: measuring how long it takes to render some pages
- Memory tests: tracking memory usage over time and potential leaks

All those tests will likely require extra software dependencies that would cause
Dillo to have a unnecessary long list of dependencies for testing.

Having tests in a separate repository allows us to test multiple releases of
Dillo with the latest test suite. We could even try to run WPT or port some of
the tests to our test suite.

Moving them outside the repository also makes the Dillo repository smaller, as
we don't have to bring unnecessary images or other potentially big files with
the browser.

The drawbacks of this approach is that we won't be able to simply run `make
check` to pass all tests in any platform.

We can develop Dillo from an old machine too, as the current requirements to
build it are not too high. Ideally we should keep the requirements for both
using Dillo and developing it about the same.

This would also lift the strict requirements to stick to old C and C++ standards
for Dillo code, but allowing them for testing.

This can be tested without disrupting the current test suite distributed with
Dillo, and then decided once we have more information on how that would work
out.


--%--
From: sjehuda
Date: Wed, 06 Nov 2024 10:00:05 +0000

Gopher and Gemini would absolutely be great to have!

--%--
From: rodarima
Date: Wed, 06 Nov 2024 12:07:20 +0000

Read the issue again.

> Gopher and Gemini would absolutely be great to have!

https://dillo-browser.github.io/#plugins

Locking.