Title: Handle OpAbort from DPI CCC server side
Author: rodarima
Created: Fri, 01 Aug 2025 21:37:10 +0000
State: closed

When loading http://elpis.ws and then the issue 10, several images are requested via the data: URL which in turn causes many calls to the DPI datauri plugin, and it seems some may fail. When the DPI server fails to reply, an OpAbort is received by the CCC, but is ignored when it comes from the server side. This leaves the connection entry stale, and when navigating backwards, an attempt to read a free chunk of memory causes a crash.

Instead of ignoring the OpAbort, we handle it as if the CCC had received an OpEnd event, which propagates the received operation to the chain and then removes the connection.

--%--
From: turboblack
Date: Tue, 05 Aug 2025 06:43:10 +0000

I am very surprised that Dillo developers read our humble magazine. Well, it is an honor.