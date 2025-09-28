Title: Reduce friction to add cookie rules
Author: rodarima
Created: Sat, 10 Feb 2024 16:26:44 +0000
State: open

When a site tries to store cookies in the browser but they are set as DENY by default, the user will need to:

- Detect that the site is trying to store cookies and are being rejected.
- Find out how to configure the cookies for that site.
- Edit manually cookiesrc and add an exception.
- Restart the dpidc daemon.

We could reduce the friction of adding new exceptions by:

- Stating that there are cookies being rejected.
- Allowing the user to add an exception from the UI directly.
- Have the configuration automatically reloaded when this happens.

See: http://bluedwarf.top/cackle/view-post.php?post_num=2584#C6