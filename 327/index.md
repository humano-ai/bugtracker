Title: ebay.com not loading
Author: rodarima
Created: Thu, 19 Dec 2024 12:48:03 +0000
State: closed

When loading https://www.ebay.com, an error appears on Dillo:

```
Service Unavailable - Zero size object
The server is temporarily unable to service your request. Please try again later.
Reference #15.3dc21302.1734611720.1dedf3d2 
https://errors.edgesuite.net/15.3dc21302.1734611720.1dedf3d2
```

The site loads well on w3m and links.

Setting `http_user_agent="w3m/0.5.3+git20230129"` makes Dillo load the site
properly.


--%--
From: rodarima
Date: Sat, 21 Dec 2024 20:43:19 +0000

Same with https://www.blick.ch/. This is likely Akamai.


--%--
From: rodarima
Date: Sun, 22 Dec 2024 17:36:00 +0000

Reported to Akamai.


--%--
From: JessFairbairn
Date: Thu, 09 Jan 2025 16:41:39 +0000

Off topic, but wow having a whitelist of useragents is so against how the web is meant to work.

--%--
From: rodarima
Date: Sat, 11 Jan 2025 17:20:39 +0000

3 weeks with no reply, giving up. Ticket: F-CS-9320406