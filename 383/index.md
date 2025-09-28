Title: Add a control socket
Author: rodarima
Created: Mon, 21 Apr 2025 11:02:28 +0000
State: open

In order to implement #47, we need first a way to talk to the correct browser process. Ideally we should be able to make dpid track all instances of the browser, so we can interact with multiple processes. But this would require implementing the logic in dillo to accept commands from the dpid interface.

A simpler mechanism (at least in the short term) is to add a UNIX socket per each dillo process, so we can talk directly to that process (say `~/.dillo/control.$PID`). We can hide the implementation details under a CLI tool where we keep the interface stable, allowing us to make changes in the underlying plumbing.

A single UNIX socket per browser process makes things much easier, as we only need to add a watcher in FLTK and process requests as they come. We can also write events such as "the page finished loaded" which are initiated by the browser itself.