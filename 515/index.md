Title: Deadlock with dilloc dump | dilloc load
Author: Rodrigo Arias Mallo
Created: Sun, 21 Dec 2025 14:42:09 +0100
State: closed

Deadlock when loading <https://url.spec.whatwg.org/> and then running:

    dilloc dump | dilloc load

It seems that the load is blocking the read() call while being unable to do
progress in the dump command. We need to implement a non-blocking load so we can
continue to do progress.

--%--
From: Rodrigo Arias Mallo
Date: Mon, 22 Dec 2025 00:38:45 +0100

Fixed in
<https://git.dillo-browser.org/dillo/commit/?id=74785c96c2fb6a359c736b57d6e66fa9bf3ce219>
