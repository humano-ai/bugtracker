Title: Implement deep reload
Author: Rodrigo Arias Mallo
Created: Sun, 28 Sep 2025 16:28:42 +0200
State: open

When reloading a file we sometimes want to reload all the embedded files
including images or linked CSS files. We can make it so that when pressing the
reload button with a modifier, the deep reload is done. By default we keep it as
it is now.

The SIGUSR1 should also perform a deep reload, so changes in CSS are also
taken into account.
