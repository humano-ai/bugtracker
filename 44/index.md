Title: Restoration of test suite and bug tracker
Author: rodarima
Created: Sat, 30 Dec 2023 12:58:31 +0000
State: open

One of the parts that got lost from the dillo.org server is the test suite that was located at `dillo.org/test`, as referred from the commit messages:

```
commit 8c6caa83a1d686091bdf5668c4c6320ce191bb93
Author: Jorge Arellano Cid <jcid@dillo.org>
Date:   Tue Aug 9 09:23:55 2016 -0400

    Merged commit #4653 (float clearance).

    Test case:

    <body>
        <div id="a">
            <div id="b" style="float:left">main</div>
        </div>
        <div id="c" style="clear:left"></div>
        <div id="d">footer</div>
    </body>


    Note: passes all the tests at
          http://www.dillo.org/test/4648/test-suite.v1.txt
```

Another piece that is no longer available is the bug tracker:
```
mio% git log | grep BUG\#
    Made show_url dillorc option work again (BUG#1128)
    BUG#1140: add show_ui_tooltip preference
    call Fl_Window::show() from Xembed::show() to make embedding easier (BUG#1127)
    Cancel the expected URL after offering a download, part 2  (BUG#982)
    BUG#948 Example: hg.dillo.org ("Contact" link).
    Cancel the expected URL after offering a download (BUG#982)
```

The last archival of the bug tracker that was not broken was this one from 2014, but none of the bugs got archived:

https://web.archive.org/web/20140408095315/http://www.dillo.org/bugtrack/Dvolunteer.html

Recovering those would be nice, so we can improve the current tests (which are very few) and get a list of pending issues, so we don't have to rediscover them again.

CC @akemnade @jfhg 

--%--
From: rodarima
Date: Sat, 30 Dec 2023 15:27:43 +0000

Some of the CSS tests got archived here: https://web.archive.org/web/20210727155831/https://www.dillo.org/css_compat/index.html

I'll try to recover them.

--%--
From: rodarima
Date: Mon, 01 Jan 2024 16:01:15 +0000

Andreas managed to get the old web page running again, so I did a backup: https://archive.org/details/website.tar