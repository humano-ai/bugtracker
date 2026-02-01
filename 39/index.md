Title: Consider other platforms to host Dillo
Author: rodarima
Created: Tue, 26 Dec 2023 14:52:58 +0000
State: closed

As discussed with @clehner, we may want to switch to a different platform that can also provide a CI system avoiding Copilot and their closed source nature.

- Codeberg: https://codeberg.org/
- GitLab instance: https://wiki.p2pfoundation.net/List_of_Community-Hosted_GitLab_Instances
- Sourcehut: https://sr.ht/

Non exaustive list of problems with GitHub:

- Copilot
- Replying by email doesn't work well: cannot close issues, markdown doesn't render and cannot attach images or files.
- Missing dependencies across issues
- Comments on issues are now JS-walled.
- Open/closed buttons on milestones no longer work in Firefox.

--%--
From: rakoo
Date: Wed, 03 Jan 2024 13:03:06 +0000

Hey there, thanks for reviving it, dillo is awesome !

Sourcehut has been cited in other places as well and will absolutely be a good place. Its focus on small, light web pages aligns with the ideas of Dillo. I'd love to see it there !

--%--
From: rodarima
Date: Thu, 11 Apr 2024 22:39:52 +0000

Nice list for GitLab: https://wiki.p2pfoundation.net/List_of_Community-Hosted_GitLab_Instances

--%--
From: fgaz
Date: Thu, 30 May 2024 08:30:34 +0000

> Its focus on small, light web pages aligns with the ideas of Dillo.

And it actually works in Dillo, I might add

--%--
From: rodarima
Date: Sun, 14 Jul 2024 17:13:52 +0000

Very large latency (~30s) observed in the Debian GitLab instance.

> Sourcehut has been cited in other places as well and will absolutely be a good place. Its focus on small, light web pages aligns with the ideas of Dillo. I'd love to see it there !

> And it actually works in Dillo, I might add

Sourcehut has a nice web interface that works from Dillo, but [Drew has opposed the usage of CI infrastructure for closed-source operative systems](https://lists.sr.ht/~sircmpwn/sr.ht-discuss/%3CC3ZF0IF242P4.3JN5FF60I1J20@keymaker.local%3E), which is fine for other FOSS projects, but not for a browser that tries to be cross-platform.

The web interface also has other (fixable) problems based on my own experience, regarding attachments and replies to patches, but those are not so much a blocker. 

Another problem with sourcehut is that self-hosting is not particularly easy, specially when multiple services are required. Right now in alpha the prices are okay, but I don't know how much they would increase them when the alpha ends.

I'm also reviewing other distributed options like [Radicle](https://radicle.xyz/) and [Fossil](https://www.fossil-scm.org/home/doc/trunk/www/index.wiki), but they also come with their own sets of drawbacks and benefits.

--%--
From: rodarima
Date: Mon, 30 Dec 2024 22:54:49 +0000

Strange situation at Sourcehut, Simon Ser [no longer works there][1]:

> You may have heard that we also had to part ways with one of our staff members
> recently. This reduces our headcount to two. For the time being we will not be
> hiring a replacement, but our near-future plans are achievable with our
> current headcount. Though we usually aim for transparency to the maximum
> extent possible, we will not be sharing further details about this departure,
> as a matter of reasonable privacy.

Simon [post][2]:

> Sadly, I need to start this status update with bad news: SourceHut has decided
> to terminate my contract. At this time, I’m still in the process of figuring
> out what I’ll do next. I’ve marked some SourceHut-specific projects as
> unmaintained, such as sr.ht-container-compose (feel free to fork of course).
> I’ve handed over hut maintenance to xenrox, and I’ve started migrating a few
> projects to other forges (more to follow). I will continue to maintain
> projects that I still use such as soju to the extent that my free time allows.

Not sure what the details are, but I don't like the lack of transparency.

[1]: https://sourcehut.org/blog/2024-06-04-status-and-plans/
[2]: https://emersion.fr/blog/2024/status-update-64/


--%--
From: rodarima
Date: Mon, 16 Jun 2025 18:07:25 +0000

Managed to a setup Woodpecker CI agent (runner) for Codeberg in the RPi 2 for tests.

--%--
From: rodarima
Date: Sun, 13 Jul 2025 21:57:29 +0000

> I'm also reviewing other distributed options like [Radicle](https://radicle.xyz/)

Radicle seems to be funded by venture capital, so they will need to find a suitable way to monetize it:

- https://www.crunchbase.com/organization/radicle-bde6
- https://tracxn.com/d/companies/radicle/__kTwrUZvI_hwDhvMbO9h4h5TPIEJ5UMCiTyi9B7YXI0Y

> Radicle has raised a total funding of $12M over 1 round. Its latest funding round was a Series B round on Feb 18, 2021 for $12M. 6 investors participated in its latest round, lead by [NFX](https://tracxn.com/d/venture-capital/nfx/__6V6UcYGwqq_nXCSVDCyXyDyfG46UkAhf0eaaGAdG4MI).
>
> Radicle has 15 institutional investors including [NFX](https://tracxn.com/d/venture-capital/nfx/__6V6UcYGwqq_nXCSVDCyXyDyfG46UkAhf0eaaGAdG4MI), [Cherry Ventures](https://platform.tracxn.com/a/d/company/55e8847ae4b0672c6cbc8808/cherry.vc) and [Coinbase](https://platform.tracxn.com/a/d/company/52bdc180e4b0420b03968e60/coinbase.com). [Naval Ravikant](https://tracxn.com/d/people/naval-ravikant/__zjY_8gmflKDzBLSv520Gkf9qM24BNrfFb_Vo_boSVAQ) and 2 others are Angel Investors in Radicle.

I don't trust VC software, it tents to get real shitty over time.

--%--
From: Rodrigo Arias Mallo
Date: Sun, 01 Feb 2026 18:27:26 +0100

Moved to our own server at <https://dillo-browser.org/> with a custom bug
tracker and cgit to serve the git repositories. We keep a backup in Sourcehut at
<https://git.sr.ht/~dillo/> and in Codeberg at <https://codeberg.org/dillo/>.

See: <https://dillo-browser.org/news/migration-from-github/>
