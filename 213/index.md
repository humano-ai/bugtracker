Title: Improve message reporting
Author: rodarima
Created: Sat, 06 Jul 2024 17:29:12 +0000
State: open

The current way in which Dillo reports problems is divided into several categories:

- HTML bugs go to the bug window.
- Errors, warnings and other informational messages go to the standard output/error.
- Some information messages go to the status bar.
- Debug messages are commented and only enabled by manually changing the code.

This ends up in a non clean console output, as well as users missing any important message when they don't open Dillo from a console.

On the other hand, it is important that we continue to have a simple standard error/output method of reporting problems, as a crash will cause the error console to be inaccesible.

So I suggest we do the following:

- Always compile all messages execept those debug messages that may be in a critical path and may affect a lot the performance (unlikely),
- Allow the bug window (or another window) to receive messages from diferent parts of the code.
- Let the user filter messages in the console window by severity (error, warning, info, debug).
- By default, propagate error messages to the stderr too (allowing the user to increase the verbosity)