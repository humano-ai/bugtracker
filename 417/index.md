Title: Google search
Author: ismaell
Created: Thu, 03 Jul 2025 06:01:31 +0000
State: closed

Google can still be used without javascript by pretending to be another browser, like W3M.

--%--
From: ismaell
Date: Thu, 03 Jul 2025 06:03:03 +0000

The search engine was removed by commit ab78cb4b3db6d63cb8da5a9d1390c2b6e50e69af.

Tested with 'User-Agent: w3m/0.5.3' over HTTP and HTTPS.

Perhaps ask Google to deliver this legacy page for Dillo too?

--%--
From: rodarima
Date: Thu, 03 Jul 2025 08:06:10 +0000

> Google can still be used without javascript by pretending to be another browser, like W3M.

I know, but is a matter of time they ban them as well as bots become aware. I would recommend not disclosing this to protect those browsers that still work. They need to add our user agent to their OK list.

> Perhaps ask Google to deliver this legacy page for Dillo too?

I already asked via the "official" channel and got AI-walled (#338). There is also another attempt [here](https://support.google.com/websearch/thread/318978583), but again it seems to be just AI on the other side. You will need to find a way to send a message to their engineers directly.

Notice you can add it yourself to the list of search engines by tweaking the configuration file. However, I would recomend reducing our dependency on Google and using alternative search engines not funded by advertising.

In case their are listening, a better way of dealing with bots is to add a dynamic proof of work like Tor is doing, which is embedded directly on the TLS protocol so all tools transparently inherit the benefits, without all the JS non-sense. See https://blog.torproject.org/introducing-proof-of-work-defense-for-onion-services/ and https://nlnet.nl/project/TLS-Client-PoW/.

--%--
From: rodarima
Date: Mon, 07 Jul 2025 21:26:50 +0000

Closing until they don't unblock Dillo.