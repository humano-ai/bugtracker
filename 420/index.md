Title: Show an error page in the canvas
Author: rodarima
Created: Fri, 11 Jul 2025 22:53:30 +0000
State: open

Instead of having to rely on the console log or the status bar to provide extra details, we can also display an internal page that explains what problem prevented the current page from loading so it is more user friendly.

We can use a internal page like `about:error` so it is visible on the location bar that is coming from Dillo and not a website. Additional information like the URL and other messages can be passed in a POST request, so it is not exposed in the URL.

We need to make sure that pages cannot embed, redirect or link to an error page, similar to DPI links.