Title: Deadlock with dilloc dump | dilloc load
Author: Rodrigo Arias Mallo
Created: Sun, 21 Dec 2025 14:42:09 +0100
State: open

Deadlock when loading <https://url.spec.whatwg.org/> and then running:

    dilloc dump | dilloc load

It seems that the load is blocking the read() call while being unable to do
progress in the dump command. We need to implement a non-blocking load so we can
continue to do progress.
