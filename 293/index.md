Title: Cache issue when login into codeberg
Author: rodarima
Created: Sun, 27 Oct 2024 16:04:29 +0000
State: open

At first I thought login into Codeberg was not working, as I was being redirected to the main page again. However, the issue is that is not being fetched again, and is serving it from the cache, even if I am now logged in. Steps to reproduce:

- Enable cookies for codeberg.org
- Go to codeberg.org
- Login
- Same main page is redirected.

On reload, the proper page is shown. The logout functionality seems to be broken without JS, so I need to remove the cookie by hand.