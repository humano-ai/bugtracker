Title: bookmark sections' title lines look confusing
Author: drawkula
Created: Tue, 09 Apr 2024 15:14:59 +0000
State: closed

The titles of the bookmark sections look like progress bars.
Probably a side effect of their title length.

![image](https://github.com/dillo-browser/dillo/assets/9768622/1e17b35e-05b6-4eab-8d7d-558a61475cf6)


--%--
From: rodarima
Date: Tue, 09 Apr 2024 15:19:38 +0000

This should be fixed in master (see https://github.com/dillo-browser/dillo/pull/111 and https://github.com/dillo-browser/dillo/pull/115).

--%--
From: drawkula
Date: Tue, 09 Apr 2024 16:02:25 +0000

According to `git log` it is a fresh source ... but I still may have 20 left thumbs with GUIs...

![image](https://github.com/dillo-browser/dillo/assets/9768622/00a1d66d-e939-4169-a63e-6e500b4f790d)


--%--
From: rodarima
Date: Tue, 09 Apr 2024 16:20:47 +0000

How are you installing Dillo after building it?, and what is the value of the path of `dpi_dir` in `~/.dillo/dpidrc`?

You may be running the bookmark plugin from another installation where `dpi_dir` is pointing to. If so, try setting `dpi_dir` it to the location you installed the new Dillo (see the `--prefix=...` flag at configure time).

--%--
From: drawkula
Date: Wed, 10 Apr 2024 02:30:46 +0000

Can (under some strange circumstances) `dpid` and the old `/opt/dillo/lib/dillo/dpi/bookmarks/bookmarks.dpi` have been still running?

Despite rebuilding several times I could not see the new bookmarks yesterday, gave up, but today I see a change without rebuilding.  In between the system only was suspended, not rebooted and since the last try where I still saw the old bookmarks there was no new rebuild/install.

I closed a freshly started `dillo` again and still see...
```
$ ps U$USER | egrep 'dpi|dillo'
1281453 ?        S      0:00 dpid
1281454 ?        S      0:00 /opt/dillo/lib/dillo/dpi/bookmarks/bookmarks.dpi
1281604 pts/2    S+     0:00 grep -E dpi|dillo
```
Not waiting for a timeout or such now... killing them.

That's my best candidate for an explanation so far.


--%--
From: rodarima
Date: Wed, 10 Apr 2024 18:52:18 +0000

> Can (under some strange circumstances) `dpid` and the old `/opt/dillo/lib/dillo/dpi/bookmarks/bookmarks.dpi` have been still running?

Yes, dpid keeps running for some time as well as the bookmarks.dpi (or any other *server* plugin recently used). To stop the daemon and the plugins you can use:

```
$ dpidc stop
```

Dillo will start dpid again next time and load the new plugins.