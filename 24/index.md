Title: Split tests into directories and run them with "make check"
Author: rodarima
Created: Thu, 21 Dec 2023 00:13:00 +0000
State: closed

Graphical tests for the Dillo Widget (dw) are moved into test/dw, the rest of unit tests are in test/unit.

Most of the tests require manual intervention from humans. This MR makes some of the unit tests work on their own.

See #15 