Title: Fingerprinting
Author: rodarima
Created: Sun, 14 Apr 2024 13:27:44 +0000
State: open

We may want to have some estimate in the amount of entropy we are leaking to find out what is the current fingerprinting capability of a given adversary when using Dillo. Setting the user agent to Dillo already cuts the whole population to probably less than 1ppm, but that is easily solvable.

Not having support for JavaScript certainly helps, but we may be still leaking some information in HTTP headers or in the way we deal with the sockets.

AFAIK, there is no tool to measure uniqueness that works without JS.

https://www.w3.org/TR/fingerprinting-guidance/
https://2019.www.torproject.org/projects/torbrowser/design/#fingerprinting-linkability

--%--
From: rodarima
Date: Sun, 14 Jul 2024 15:16:11 +0000

Related: https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/message/6C5K4F6NBRUDSPNPWTXLQXCK3U3SI7DM/