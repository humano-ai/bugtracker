Title: Load a list of sites when running the tests
Author: rodarima
Created: Sun, 09 Jun 2024 11:46:00 +0000
State: open

Regarding #190, we should add some lists of sites which will be used to ensure Dillo can parse them without a segfault.

Rather than making the pages local in a test repository, we can just try to open them online and fail if they cannot be loaded. Those pages that go down must be taken out of the test suite. This will also exercise the TLS and other network facing code.

We can begin with a 5 minute CI test, so we don't increase too much the test run times. We need to be able to signal the test driver that the site has loaded properly.

--%--
From: rodarima
Date: Sun, 09 Jun 2024 12:00:48 +0000

Here are some: https://github.com/scrapy/protego/blob/master/tests/top-10000-websites.txt