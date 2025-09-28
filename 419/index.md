Title: Detect IPv6 support at configure time
Author: rodarima
Created: Fri, 11 Jul 2025 20:22:12 +0000
State: closed

Adds a new configure test to detect if libc supports IPv6, **NOT if the current network supports IPv6**.

At runtime, hosts that are only reachable via IPv6 when the support is enabled but the network doesn't support IPv6 will result in an inmediate error to connect that is displayed in the status bar. All IPs returned from the DNS are tested, and IPv4 seems to always be tested first. So I don't think we need to explictly disable IPv6 with a config option in dillorc, but we could add it later if we encounter problems.

This change effectively **enables support for IPv6 by default** when Dillo is built in a platform that has IPv6 support, which is most of them. Users can override the detection and explicitly set the outcome by using `--enable-ipv6` or `--disable-ipv6`.

Fixes #167 