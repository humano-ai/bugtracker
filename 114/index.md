Title: Fix HTML validator menu
Author: rodarima
Created: Mon, 01 Apr 2024 20:34:11 +0000
State: closed

The W3C validator is now protected under a CloudFlare JavaScript challenge. However, it can be bypassed by opening directly the link after the redirection. It doesn't work if an HTML 5 page is loaded, as that would redirect to the Nu validator which will attempt to run the challenge again.

So the current solution is to use the "legacy" W3C validator for HTML 4.01 or older documents and the W3C Nu validator for HTML 5 documents only. Users would need to choose which one to use manually (at least for now).

The WDG validator at https://www.htmlhelp.org/tools/validator/ is gone, the server reports "Server unable to read htaccess file, denying access to be safe", so it has been removed.

Fixes: https://github.com/dillo-browser/dillo/issues/113