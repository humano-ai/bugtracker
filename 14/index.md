Title: Fix DuckDuckGo search links
Author: rodarima
Created: Sun, 17 Dec 2023 19:15:33 +0000
State: closed

The DuckDuckGo service that redirects the links from the search page is returning a broken page for non-javascript browsers. They have a meta refresh tag in the body, instead of in the head.

Adding the kd=-1 argument causes the DuckDuckGo search results to point directly to the target page avoiding the redirection.

Fixes: #8 