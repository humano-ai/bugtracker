Title: XMPP PubSub
Author: sjehuda
Created: Wed, 06 Nov 2024 11:28:32 +0000
State: closed

Please add support for XMPP.

By adding support for XMPP, I namely mean to [Atom Over XMPP](https://blasta.woodpeckersnest.eu/help/about/xmpp/atomsub) (XEP-0277 and XEP-0472) which is utilizing XEP-0060: Publish-Subscribe (PubSub) which allows to host "rich" content on XMPP.

This is a visual demonstration to prove that subject matter https://video.xmpp-it.net/w/vNqcMooy3pqRAZ8Yb8grr1

[Rivista XJP](https://git.xmpp-it.net/sch/Rivista) is an HTTP gateway to deliver posts from the XMPP network.

See also:
- https://xmpp.org/extensions/xep-0060.html
- https://xmpp.org/extensions/xep-0277.html
- https://xmpp.org/extensions/xep-0472.html
- https://blasta.woodpeckersnest.eu/help/about/xmpp/pubsub
- https://join.movim.eu/

For example, the journal at https://mov.im/blog/edhelas is not hosted at mov.im; rather, it is hosted inside an account at XMPP server movim.eu which is conveyed by the Movim instance at mov.im.

Please join to JDev group chat if you want more help or information https://search.jabber.network/search?q=jdev

Related: https://github.com/crossbowerbt/dillo-plus/issues/54

--%--
From: rodarima
Date: Wed, 06 Nov 2024 12:00:25 +0000

> [Rivista XJP](https://git.xmpp-it.net/sch/Rivista) is an HTTP gateway to deliver posts from the XMPP network.

What is wrong with this gateway?

--%--
From: sjehuda
Date: Wed, 06 Nov 2024 17:48:24 +0000

This gateway works fine.

Proof of concept
----------------

The gateway was intended only for feed readers; and yet, with XSLT, I
have made it usable for HTML browsers too, but this gateway is really a
proof-of-concept, albeit it is competent for content publishing.


The subject matter
------------------

Dillo is an HTML browser, which parses HTML; so, I would suggest to add
support for XMPP, which would:

1) Allow to view HTML content which is stored on XMPP.
2) Be extensible to comment on XMPP PubSub posts and also to publish
   posts to XMPP PubSub.


The benefit of XMPP PubSub structure
------------------------------------

The item and node fashion, by which XMPP PubSub is designed, allow for
efficient usage of bandwidth on both ends (client and server).

Please. Try the gateway, especially the part which allows to view
single posts (i.e. Item ID), to observe this statement.


Conclusion
----------

I firmly suggest to consider this feature.


--%--
From: sjehuda
Date: Wed, 06 Nov 2024 17:50:18 +0000

Is it possible to write a plugin with Python?

I would be glad to contribute an XMPP plugin.

https://dillo-browser.github.io/#plugins


--%--
From: rodarima
Date: Wed, 06 Nov 2024 18:43:48 +0000

Yes, you can make a plugin in Python as long as you output HTML that Dillo can parse. See the available plugins as examples.

Maybe you use something like [miniflux](https://miniflux.app/) as a web reader interface, so you can just connect your gateway to miniflux and read the feeds from there via HTTP as HTML.

--%--
From: sjehuda
Date: Wed, 06 Nov 2024 18:59:17 +0000

I will use Slixmpp to retrieve HTML content from XMPP PubSub nodes.

I suppose, that I will use my own design.

I will continue at the mailing list.

Thank you.




