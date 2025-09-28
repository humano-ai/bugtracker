Title: Add plugin for geo: URLs
Author: rodarima
Created: Sat, 25 Jan 2025 14:05:15 +0000
State: closed

I'm just opening the issue here so I don't forget, but it should probably be done in a separate plugin.

The geo: URL scheme was designed to locate places on Earth (other planets seem to be also supported) which I like a lot. It is an agnostic identifier, so you are not tied to a single provider like Google Maps or Open Street Map, so you decide where to open it.

https://en.wikipedia.org/wiki/Geo_URI_scheme

Here is the RFC:

https://datatracker.ietf.org/doc/html/rfc5870

This also shows that we should be able to assign custom handlers (applications) to open certain protocols, rather than trying to display them on the browser. In my case, I would love to add support to lightweight map viewers like florb.

--%--
From: rodarima
Date: Wed, 05 Feb 2025 20:38:28 +0000

This can be done with the link actions: https://github.com/rodarima/florb/tree/open-geo-links

Closing.