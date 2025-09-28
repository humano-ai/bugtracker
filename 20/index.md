Title: Support for other SSL libraries
Author: rodarima
Created: Tue, 19 Dec 2023 18:56:44 +0000
State: closed

On 2016, corvid [changed the SSL implementation](https://github.com/dillo-browser/dillo/commit/b6247cde66c1450a6fccde9bfb100ee776af2571) from OpenSSL to [mbedTLS](https://github.com/Mbed-TLS/mbedtls) (previously polarSSL). The change makes Dillo depend on mbedTLS only, while before it was possible to link it with LibreSSL and OpenSSL. Other forks like [dillo-plus](https://github.com/crossbowerbt/dillo-plus/commits/main/src/IO/tls.c) have changed back to OpenSSL.

We may want to reevaluate which SSL libraries we want Dillo to support.

Here is a useful comparison from Curl:

https://curl.se/docs/ssl-compared.html

The good point of mbedTLS is that is small, so we can build Dillo with TLS support on small (embeded) devices. However, the WolfSSL library is also small and suitable for embedded devices while at the same time it has an API compatible with OpenSSL.

On the other hand, a lot of packages already have a dependency with OpenSSL, so if we can link with it we wouldn't need to pull any extra dependencies on desktops.

Supporting at least OpenSSL and wolfSSL seems to be a good tradeoff.

--%--
From: rodarima
Date: Tue, 19 Dec 2023 23:35:00 +0000

Here is the mailing list thread that initiated the switch to mbedTLS (eocene = corvid):

https://groups.google.com/g/dillo/c/pFOpRyMcr20/m/i3kfLdbYAQAJ

<details>
  <summary>Here is a (partial) copy of the thread</summary>

eocene
Jun 19, 2016, 10:50:59 PM
to dill...@dillo.org

I wanted to see what it would take to use mbed tls with dillo.

I put a copy of the diff at http://www.dillo.org/test/mbedtls.diff
and I mention it here in case someone should want that one day.


That said, it looks like netsurf uses curl, and curl can use any
tls library you care to mention. And I'm pretty sure netsurf does
javascript. 

---

Jorge Arellano Cid
unread,
Jun 20, 2016, 4:12:06 AM
to dill...@dillo.org
Hi,

On Sun, Jun 19, 2016 at 08:48:28PM +0000, eocene wrote:
>
> I wanted to see what it would take to use mbed tls with dillo.
>
> I put a copy of the diff at http://www.dillo.org/test/mbedtls.diff
> and I mention it here in case someone should want that one day.

What's the main point/difference in using mbedtls vs OpenSSL?


> That said, it looks like netsurf uses curl, and curl can use any
> tls library you care to mention. And I'm pretty sure netsurf does
> javascript.

Sorry, I don't get the point here.


-- 
Cheers
Jorge.- 

---

eocene
unread,
Jun 20, 2016, 5:33:51 AM
to dill...@dillo.org
> What's the main point/difference in using mbedtls vs OpenSSL?

OpenSSL is such a notorious nightmare--one gets the distinct
impression that the developers have not taken their responsibility
seriously--that I was curious to try a different one that is
supposed to be more comprehensible.

mbed tls had been on my mind as something I might want to try
someday after they implement OCSP stapling, but then I was just in
the mood for it the other day.

As for how practical it would ever be to have this code in the real
dillo someday, I think that comes down to: How good are distributions
at making security updates available for their more obscure packages?

> > That said, it looks like netsurf uses curl, and curl can use any
> > tls library you care to mention. And I'm pretty sure netsurf does
> > javascript.
>
> Sorry, I don't get the point here.

I was thinking how if someone did get the idea in their head that
they wanted a small browser that works with mbed tls, dillo might
not be the first choice. 

---

Johannes Hofmann
unread,
Jun 20, 2016, 10:13:12 AM
to dill...@dillo.org
On Sun, Jun 19, 2016 at 08:48:28PM +0000, eocene wrote:
>
> I wanted to see what it would take to use mbed tls with dillo.
>
> I put a copy of the diff at http://www.dillo.org/test/mbedtls.diff
> and I mention it here in case someone should want that one day.

Excellent. I like mbedtls (formerly known as PolarSSL). The code
looks much saner to me than openssl.

Cheers,
Johannes 

---

eocene's profile photo
eocene
unread,
Jun 20, 2016, 7:43:22 PM
to dill...@dillo.org
I wrote:
> As for how practical it would ever be to have this code in the real
> dillo someday, I think that comes down to: How good are distributions
> at making security updates available for their more obscure packages?

I realized this is an exceedingly trivial concern when compared with the
fact that distributions have configured dillo with --enable-ssl for
years despite the state of the old dpi and our all-caps warnings, thereby
causing users to trust something they shouldn't. 

---

Jorge Arellano Cid
unread,
Jun 24, 2016, 5:36:44 PM
to dill...@dillo.org
On Mon, Jun 20, 2016 at 10:10:54AM +0200, Johannes Hofmann wrote:
> On Sun, Jun 19, 2016 at 08:48:28PM +0000, eocene wrote:
> >
> > I wanted to see what it would take to use mbed tls with dillo.
> >
> > I put a copy of the diff at http://www.dillo.org/test/mbedtls.diff
> > and I mention it here in case someone should want that one day.
>
> Excellent. I like mbedtls (formerly known as PolarSSL). The code
> looks much saner to me than openssl.

If you both agree it's a better lib than OpenSSL, +1.

-- 
Cheers
Jorge.- 

---

eocene's profile photo
eocene
unread,
Jul 3, 2016, 6:40:12 PM
to dill...@dillo.org
Jorge wrote:
> On Mon, Jun 20, 2016 at 10:10:54AM +0200, Johannes Hofmann wrote:
> > On Sun, Jun 19, 2016 at 08:48:28PM +0000, eocene wrote:
> > >
> > > I wanted to see what it would take to use mbed tls with dillo.
> > >
> > > I put a copy of the diff at http://www.dillo.org/test/mbedtls.diff
> > > and I mention it here in case someone should want that one day.
> >
> > Excellent. I like mbedtls (formerly known as PolarSSL). The code
> > looks much saner to me than openssl.
>
> If you both agree it's a better lib than OpenSSL, +1.

All right, then. *commits*

If you need mbed TLS 2.x: https://tls.mbed.org/download


If you watch the MSGs, you'll see I've turned off the certificate chain
printing and instead show a more concise summary at shutdown of which
root certificates were used to verify communication with which servers.

And at startup it'll tell you how many such certificates you are trusting.
By default, I had 174, but I've trimmed them down on this computer to...twenty
at the moment because I never need the ones from certificate authorities in
China, Turkey, Hungary, etc. 

</details>

Which caused the initial commit:

```
commit b6247cde66c1450a6fccde9bfb100ee776af2571
Author: corvid <devnull@localhost>
Date:   Sun Jul 3 16:09:21 2016 +0000

    use mbed TLS

 AUTHORS      |    2 -
 ChangeLog    |    7 +-
 configure.ac |   11 +-
 src/IO/IO.c  |   23 ++-
 src/IO/tls.c | 1389 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------------------------
 5 files changed, 674 insertions(+), 758 deletions(-)
```