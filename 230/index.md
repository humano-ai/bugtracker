Title: Dillo will be removed from Debian testing on August 23rd
Author: rodarima
Created: Thu, 25 Jul 2024 20:03:18 +0000
State: closed

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1074911

> Version 3.0.5-7 of dillo is marked for autoremoval from testing on Fri 23 Aug 2024. It is affected by [#1074911](https://bugs.debian.org/1074911). The removal of dillo will also cause the removal of (transitive) reverse dependency: [claws-mail](https://tracker.debian.org/pkg/claws-mail). You should try to prevent the removal by fixing these RC bugs.

It seems clear now that the package is not maintained anymore (see #216), so before it goes into the abyss we may be able to find someone who can adopt it.

--%--
From: rodarima
Date: Mon, 29 Jul 2024 19:46:42 +0000

Hi @xtaran, are you aware of this?

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1074911

If I understand correctly, the Dillo package in Debian will be removed for the next release due a failure to build.

The 3.0.5 release is 9 years old so I recommend you update it, rather than continue to patch it, as there are a lot of changes that were not released [until 3.1.0 which were written by the original developers](https://dillo-browser.github.io/release/3.1.0/) (specially related to TLS).

[The original upstream is gone](https://dillo-browser.github.io/dillo.org.html) and this repository is an effort to continue the project, with the last release being 3.1.1.

I opened a MR in the Debian repository two weeks ago, with an updated package to 3.1.1 that builds and seems to run fine based on my tests and what people have reported (see #216), which also should get rid of the FTBFS problem:

https://salsa.debian.org/debian/dillo/-/merge_requests/1

If you cannot take care of it, would you be open for someone else to adopt it? I'm not familiar with Debian packaging but I could ask around.

It seems this is also taking down claws-mail (CC @mones), due to the dependency with Dillo.

I'll also CC @johnraff from BunsenLabs, as for the context of:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1022726

For reference, here is the packaging state on other distros, which shows most have updated to 3.1.1 already:

https://repology.org/project/dillo/history

--%--
From: johnraff
Date: Tue, 30 Jul 2024 02:08:26 +0000

I have forked this repository and added some packaging content here:
https://github.com/BunsenLabs/dillo-browser
I imported the 3.1.1 tarball [here](https://github.com/BunsenLabs/dillo-browser), made a few [changes](https://github.com/BunsenLabs/dillo-browser/commits/v3.1.1) and successfully built (on pbuilder) a package from that:
https://pkg.bunsenlabs.org/debian/pool/main/d/dillo/dillo_3.1.1-0.1~bl3_amd64.deb

The dillo code from dillo-browser has not been touched at all, and most of the packaging is @xtaran's work.

But this package has been built for BunsenLabs and will likely not be acceptable in Debian as-is.

The ideal would be if @xtaran were willing to continue maintaining the package, but he seems to be very busy with other projects and it would be understandable if he wanted to drop it at this point.

I'm not a Debian Maintainer and could not take over, but I would be willing to co-operate with someone with the necessary credentials. There were not so many changes needed to make the package buildable.

--%--
From: rodarima
Date: Sun, 04 Aug 2024 11:26:33 +0000

> I have forked this repository and added some packaging content here: https://github.com/BunsenLabs/dillo-browser I imported the 3.1.1 tarball [here](https://github.com/BunsenLabs/dillo-browser), made a few [changes](https://github.com/BunsenLabs/dillo-browser/commits/v3.1.1) and successfully built (on pbuilder) a package from that: https://pkg.bunsenlabs.org/debian/pool/main/d/dillo/dillo_3.1.1-0.1~bl3_amd64.deb

Oh, thanks! I didn't see this before.

> The dillo code from dillo-browser has not been touched at all, and most of the packaging is @xtaran's work.
> 
> But this package has been built for BunsenLabs and will likely not be acceptable in Debian as-is.
> 
> The ideal would be if @xtaran were willing to continue maintaining the package, but he seems to be very busy with other projects and it would be understandable if he wanted to drop it at this point.
> 
> I'm not a Debian Maintainer and could not take over, but I would be willing to co-operate with someone with the necessary credentials. There were not so many changes needed to make the package buildable.

I'm also not able to maintain it myself, as I'm not too familiar with Debian packages, but maybe I can find someone who does, I'll ask around.

--%--
From: rodarima
Date: Sun, 04 Aug 2024 11:51:27 +0000

Relevant:

https://www.debian.org/doc/manuals/developers-reference/beyond-pkging.html#mia-qa
https://wiki.debian.org/qa.debian.org/MIATeam

--%--
From: ArrayBolt3
Date: Sun, 04 Aug 2024 16:51:08 +0000

Ubuntu dev with Debian developer connections here. I depend on Claws Mail for my workflow so I'm willing to pick up Dillo. (Actually I build Claws from source so my workflow doesn't *totally* depend on Dillo, but nonetheless I want Claws to remain in Debian and Dillo also seems very useful.)

--%--
From: rodarima
Date: Sun, 04 Aug 2024 19:27:11 +0000

It looks @mirabilos is going to address the "failure to build" problem:

https://toot.mirbsd.org/@mirabilos/statuses/01J4FCY6M75VFD1HB0ZS2QYV5A

One of the other problems that prevents the update to 3.1.1 is the lack of trust to change the upstream, which is understandable. Not sure if we can do much on our side to solve that, other than waiting for trusted Debian developers to review the changes.

--%--
From: ArrayBolt3
Date: Sun, 04 Aug 2024 23:52:42 +0000

For what it's worth v3.1.1 builds with GCC14 as-is for me, in a Debian Sid build environment.

--%--
From: Mechtilde
Date: Mon, 05 Aug 2024 04:38:45 +0000

now in the right issue

Hello,
please slow down.
First the package will be removed from testing because the build failed with gcc-14.

You can create a bugreport against dillo and provide your help.
You can start to learn to build a proper Debian package, esp with git-buildpackage and the other used tools.
For this you can start at mentors.debian.net ad follow that description.

I saw your MR at salsa.debian.org. It doesn't build. So it can't be accepted.

For more information please ask.


--%--
From: johnraff
Date: Mon, 05 Aug 2024 06:42:48 +0000

There is my attempt at a "proper Debian package" as referenced above, here: https://github.com/BunsenLabs/dillo-browser/tree/v3.1.1
This builds in a pbuilder Trixie environment with no Lintian errors, just two Pedantic warnings.

So most of the Debianizing work has already been done. What remains is the [FTBFS with GCC-14](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1074911) which presumably arises when building on Sid, although judging by @ArrayBolt3 's post, the 3.1.1 code may already have that covered.

--%--
From: johnraff
Date: Mon, 05 Aug 2024 06:46:27 +0000

> It looks @mirabilos is going to address the "failure to build" problem:
> 
> https://toot.mirbsd.org/@mirabilos/statuses/01J4FCY6M75VFD1HB0ZS2QYV5A
> 

That link shows 404 for me unfortunately.

> One of the other problems that prevents the update to 3.1.1 is the lack of trust to change the upstream, which is understandable. Not sure if we can do much on our side to solve that, other than waiting for trusted Debian developers to review the changes.

I think this is probably the big one.


--%--
From: Mechtilde
Date: Mon, 05 Aug 2024 07:06:35 +0000

How did you build it? Where are the sources files, which can be uploaded? Where do you provide them, Why do you want to do an Non-Maintainer-Upload?

Why didn't you do an update of the existing package?

Please contact me for more information
Regards

Am 5. August 2024 08:43:10 MESZ schrieb John Crawley ***@***.***>:
>There is my attempt at a "proper Debian package" as referenced above, here: https://github.com/BunsenLabs/dillo-browser/tree/v3.1.1
>This builds in a pbuilder Trixie environment with no Lintian errors, just two Pedantic warnings.
>
>So most of the Debianizing work has already been done. What remains is the [FTBFS with GCC-14](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1074911) which presumably arises when building on Sid.
>
>-- 
>Reply to this email directly or view it on GitHub:
>https://github.com/dillo-browser/dillo/issues/230#issuecomment-2268293898
>You are receiving this because you commented.
>
>Message ID: ***@***.***>
-- 
Diese Nachricht wurde von meinem Android-Gerät mit K-9 Mail gesendet.

--%--
From: ArrayBolt3
Date: Mon, 05 Aug 2024 07:07:00 +0000

I also have a working Dillo 3.1.1 package, which builds against Sid (with GCC-14) without issues. It does not silence *all* warnings, however this is intentional on my part since some Debian Developers are willing to accept packages with warnings but unwilling to accept packages with warnings unnecessarily overridden even if those warnings aren't actually indicative of packaging issues or Debian policy violations.

> One of the other problems that prevents the update to 3.1.1 is the lack of trust to change the upstream, which is understandable. Not sure if we can do much on our side to solve that, other than waiting for trusted Debian developers to review the changes.

Whoever submits the package to Debian will have to do a copyright review anyway. Integrating a quick scan to make sure there are no malicious changes is probably no big deal there.

--%--
From: ArrayBolt3
Date: Mon, 05 Aug 2024 07:11:57 +0000

@Mechtilde Ahem, excuse me for asking, but who are you? Why do you want people to contact you for more information?

> How did you build it?

He said, with pbuilder. Debian packagers oftentimes have their own favorite build tools. I use sbuild myself.

> Where are the source files, which can be uploaded?

Um, he linked to the package source tree? Most any Debian package maintainer knows how to build a source package from that.

> Where do you provide them?

Again, he linked to a Debian source tree which you can build a source package from.

> Why do you want to do a Non-Maintainer Upload

Because he isn't the maintainer, and Debian requires (or at least highly recommends) these kinds of uploads to be done as non-maintainer uploads. See https://www.debian.org/doc/manuals/developers-reference/pkgs.html#nmu

> Why didn't you do an update of the existing package?

He did.

Respectfully, do you know how Debian packaging is done?

--%--
From: johnraff
Date: Mon, 05 Aug 2024 07:30:53 +0000

> I also have a working Dillo 3.1.1 package, which builds against Sid (with GCC-14) without issues.

Did you use the dillo-browser code untouched, adding only a debian/ directory? If so, we have reason for optimism!
Maybe @rodarima 's code changes have already dealt with the GCC-14 isue.

> It does not silence _all_ warnings, however this is intentional on my part since some Debian Developers are willing to accept packages with warnings but unwilling to accept packages with warnings unnecessarily overridden even if those warnings aren't actually indicative of packaging issues or Debian policy violations.

The lintian-overrides I added were to suppress warnings about long lines in html files (embedded base64 images), bugs #1017966  #1019980 #864555 possibly. I also edited a couple of existing overrides so they would work. The overrides could be removed, though. No Lintian Errors have been overridden.



--%--
From: ArrayBolt3
Date: Mon, 05 Aug 2024 07:33:14 +0000

@johnraff Correct. I basically took the existing Dillo packaging (pulled using `pull-debian-source` on my Ubuntu machine), wiped out everything except the `debian` dir, unpacked Dillo 3.1.1 untouched into the source tree alongside the `debian` dir, and then adjusted the Debian packaging as appropriate (dropping old patches, fixing mismatched Lintian overrides, no longer trying to install doc files that don't exist anymore, etc). I haven't published my source tree anywhere, but I have it and could publish it.

--%--
From: Mechtilde
Date: Mon, 05 Aug 2024 08:01:26 +0000

> @Mechtilde Ahem, excuse me for asking, but who are you? Why do you want people to contact you for more information?
> 
> > How did you build it?
> 
> He said, with pbuilder. Debian packagers oftentimes have their own favorite build tools. I use sbuild myself.
> 
> > Where are the source files, which can be uploaded?
> 
> Um, he linked to the package source tree? Most any Debian package maintainer knows how to build a source package from that.
> 
> > Where do you provide them?
> 
> Again, he linked to a Debian source tree which you can build a source package from.
> 
> > Why do you want to do a Non-Maintainer Upload
> 
> Because he isn't the maintainer, and Debian requires (or at least highly recommends) these kinds of uploads to be done as non-maintainer uploads. See https://www.debian.org/doc/manuals/developers-reference/pkgs.html#nmu
> 
> > Why didn't you do an update of the existing package?
> 
> He did.
> 
> Respectfully, do you know how Debian packaging is done?

Yes I know, how to create Debian packages. That's the reason of that questions. To get software into the Debian distribution you have to prepare the source files which can be uploaded to the archive and then build there.

I want to help you to maintain dillo yourself for the Debian project. That's the reason why i provided more help

Regards



--%--
From: Mechtilde
Date: Mon, 05 Aug 2024 08:04:02 +0000

> @johnraff Correct. I basically took the existing Dillo packaging (pulled using `pull-debian-source` on my Ubuntu machine), wiped out everything except the `debian` dir, unpacked Dillo 3.1.1 untouched into the source tree alongside the `debian` dir, and then adjusted the Debian packaging as appropriate (dropping old patches, fixing mismatched Lintian overrides, no longer trying to install doc files that don't exist anymore, etc). I haven't published my source tree anywhere, but I have it and could publish it.

you can provide the source files via mentors.debian.net

--%--
From: johnraff
Date: Mon, 05 Aug 2024 08:15:29 +0000

> @johnraff I basically took the existing Dillo packaging (pulled using `pull-debian-source` on my Ubuntu machine), wiped out everything except the `debian` dir, unpacked Dillo 3.1.1 untouched into the source tree alongside the `debian` dir, and then adjusted the Debian packaging as appropriate (dropping old patches, fixing mismatched Lintian overrides, no longer trying to install doc files that don't exist anymore, etc). 

It sounds as if we both did pretty much the same thing.

I did take some care to preserve the git histories of both @rodarima 's and @xtaran 's code, though. If you go back in the commits on the repo I published, after @rodarima you'll eventually come to @xtaran's packaging commits, then the original dillo developers' work. It's all there.

For whatever it's worth, the notes I kept:
```
How to merge in the debian/ directory from eg debian salsa,
into an existing eg github repo, keeping history:

( this was forked from https://github.com/dillo-browser/dillo )
git clone git@github.com:BunsenLabs/dillo-browser.git
(on branch master)
git checkout -b packaging
make debian/ directory (git will ignore it)
git remote add salsa git@salsa.debian.org:debian/dillo.git
git fetch salsa
git merge --allow-unrelated-histories -s ours --no-commit salsa/master
git read-tree --prefix=debian/ -u salsa/master:debian
git commit -m 'Add debian directory from https://salsa.debian.org/debian/dillo'
(check that only debian/ files have been added)
git diff --name-only master

see:
https://stackoverflow.com/questions/1214906/how-do-i-merge-a-sub-directory-in-git
https://stackoverflow.com/questions/62927619/git-error-not-a-valid-object-name-when-merging-subfolder-of-repository-into-sub

(if a merge gets messed up)
git merge --abort
(revert the last commit)
git reset --hard HEAD~1
```






--%--
From: ArrayBolt3
Date: Mon, 05 Aug 2024 08:25:51 +0000

On Mon, Aug 5, 2024 at 3:04 AM Mechtilde ***@***.***> wrote:

> @johnraff <https://github.com/johnraff> Correct. I basically took the
> existing Dillo packaging (pulled using pull-debian-source on my Ubuntu
> machine), wiped out everything except the debian dir, unpacked Dillo
> 3.1.1 untouched into the source tree alongside the debian dir, and then
> adjusted the Debian packaging as appropriate (dropping old patches, fixing
> mismatched Lintian overrides, no longer trying to install doc files that
> don't exist anymore, etc). I haven't published my source tree anywhere, but
> I have it and could publish it.
>
> you can provide the source files via mentors.debian.net
>

I am aware. I haven't done so yet since I would like to test the package
before requesting sponsorship, and am not sure who exactly is going to take
maintainership of it in the event the original maintainer is absent. (It
looks like Dillo's call for help on Mastodon got more than one person
interested, and I don't want to end up "fighting" anyone
for maintainership.)

—
> Reply to this email directly, view it on GitHub
> <https://github.com/dillo-browser/dillo/issues/230#issuecomment-2268429478>,
> or unsubscribe
> <https://github.com/notifications/unsubscribe-auth/AZAFFEWD5OYXWYAZZXP4YFLZP4WYTAVCNFSM6AAAAABLPHB5ZOVHI2DSMVQWIX3LMV43OSLTON2WKQ3PNVWWK3TUHMZDENRYGQZDSNBXHA>
> .
> You are receiving this because you were mentioned.Message ID:
> ***@***.***>
>


--%--
From: Mechtilde
Date: Mon, 05 Aug 2024 08:36:43 +0000

There is no need to fear ending up  "fighting" anyone for maintainership.
We know each other ;-)


--%--
From: johnraff
Date: Mon, 05 Aug 2024 08:57:31 +0000

> It looks like Dillo's call for help on Mastodon got more than one person interested, and I don't want to end up "fighting" anyone for maintainership.

Still less me. My code is there if anyone should want to borrow bits. Very happy if someone wants to take on the maintainership of dillo so it remains in the Debian repositories. :)

--%--
From: ArrayBolt3
Date: Mon, 05 Aug 2024 09:20:59 +0000

On Mon, Aug 5, 2024 at 3:57 AM John Crawley ***@***.***>
wrote:

> It looks like Dillo's call for help on Mastodon got more than one person
> interested, and I don't want to end up "fighting" anyone for maintainership.
>
> Still less me. My code is there if anyone should want to borrow bits. Very
> happy if someone wants to take on the maintainership of dillo so it remains
> in the Debian repositories. :)
>
Ah, ok. If no one's taken it by the time I wake up next, I'll very likely
upload my results. I will be using your Git magic though, that was really
neat :)

> —
> Reply to this email directly, view it on GitHub
> <https://github.com/dillo-browser/dillo/issues/230#issuecomment-2268533964>,
> or unsubscribe
> <https://github.com/notifications/unsubscribe-auth/AZAFFEXCBZCV5BKOZLUPIUTZP45BDAVCNFSM6AAAAABLPHB5ZOVHI2DSMVQWIX3LMV43OSLTON2WKQ3PNVWWK3TUHMZDENRYGUZTGOJWGQ>
> .
> You are receiving this because you were mentioned.Message ID:
> ***@***.***>
>


--%--
From: Mechtilde
Date: Mon, 05 Aug 2024 10:30:01 +0000

Dillo ist still in the Debian Repo.
To get the update into the Debian Repo, too, the best way is to provide the source packages of the new version and a sponsor can pick it up, review and upload it.
That can be done via mentors.debian.net 

--%--
From: xtaran
Date: Mon, 05 Aug 2024 13:20:14 +0000

> Dillo ist still in the Debian Repo.

There is no "the Debian repo".

And it is neither endangered to be removed from Debian Unstable nor Stable. The removal will be just from Testing.

> To get the update into the Debian Repo, too, the best way is to provide the source packages of the new version and a sponsor can pick it up, review and upload it. That can be done via mentors.debian.net

In that case, the sponsor will have a lot of work and a great responsibility in avoiding an xz situation as we're talking about the switch of upstream towards a repo where not any of the previous upstream developers seems to be involved: https://chaos.social/@xtaran/112905124915743612

--%--
From: rodarima
Date: Mon, 05 Aug 2024 15:09:20 +0000

> And it is neither endangered to be removed from Debian Unstable nor Stable. The removal will be just from Testing.

I updated the issue title. Sorry for the confusion, I'm not familiar with Debian packaging.

> > To get the update into the Debian Repo, too, the best way is to provide the source packages of the new version and a sponsor can pick it up, review and upload it. That can be done via mentors.debian.net
> 
> In that case, the sponsor will have a lot of work and a great responsibility in avoiding an xz situation as we're talking about the switch of upstream towards a repo where not any of the previous upstream developers seems to be involved: https://chaos.social/@xtaran/112905124915743612

I understand not trusting a change in upstream. I'll be happy if any of the previous developers wants to join the organization (that was the main point to create one). I have invited Johannes and Jeremy to the Dillo organization, but I don't think others are on GitHub.

But I also don't want it to become stuck in 3.0.5 forever, as we have users in Debian or Debian-derived distros who are not capable of building it from source on their own, and they are experiencing broken sites or problems with TLS that are solved in 3.1.1.

I think it is posible to review the changes I introduced since the last trusted commit in a reasonable time frame, as most of the work was done by Sebastian but never made it into an official release. You can see it [here](https://dillo-browser.github.io/release/3.1.0/):

![](https://dillo-browser.github.io/release/3.1.0/commits-author.png)

If you trust other Debian maintaners, I can ask them to take a look too if you don't have the time to do yourself. I don't think any of the original developers will be involved in Dillo anymore, but [I have mailed them anyway](https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/thread/HCADTQQAT52ARCFRPVR7ANS7BID3MD4X/).

--%--
From: ArrayBolt3
Date: Mon, 05 Aug 2024 21:23:49 +0000

@xtaran I don't see how this will be all that difficult to audit. We know the existing Dillo code is trusted, there aren't that many changes from older Dillo to newer Dillo, and whoever updates the package (I'm intending to do that) will have to do a copyright review, putting them in a rather good position to do a code safety review. Does that seem like a valid assessment to you? I'm happy to be the one who checks the diff between the two.

(FWIW I've seen this continuation of Dillo around for a while, this isn't a new thing suddenly springing up in order to compromise Dillo in Debian to my awareness. I do not yet trust the authors, but I can fix that easily enough by looking at their code.)

--%--
From: mirabilos
Date: Mon, 05 Aug 2024 21:43:49 +0000

@all,

why am I on this totally pointless discussion?

1. the maintainer is @xtaran, so right now he decides what goes in
2. I already said I’m going to jump in and help with fixing the
   current rc bug, so dillo can stay in Debian
   ⇒ you can close this issue, full stop.
3. the package has an active maintainer, so nobody should get up
   trying to suggest a different packaging as that would be an
   inadmissible hostile takeover
4. we’re having to try to avoid a Jia Tan situation
5. the entire situation with the domain going away (which, yes,
   is not the fault of the new developers), the old developers
   vanishing (same), etc. doesn’t make this easy


Aaron Rainbolt dixit:

>@xtaran I don't see how this will be all that difficult to audit. We

Why are you trying to pressure him so much about this?

*Are* you, perchance, a Jia Tan?

We’ve already stated in the thread around
***@***.***/statuses/01J4FBZDZRRWTDFNKKQSGFDET7
what’s happening, how to proceed, etc. and what not to do.

I fully expect this discussion to finish here right now.
Those not involved with the new Dillo project should, please,
just shut up, and those involved better not be involved in
pressuring the Debian maintainer and other Debian Developers
and packagers lest their behaviour be judged to be akin to
a Hans Jansen situation.

Thank you.


Note: all this time spent discussing things uses up spoons.
Spoons which then aren’t available to do the actual work any
more. I’ve dealt with xloadimage yesterday, whose deadline
was even closer (a few days). I can ensure that, if I don’t
need to waste effort on discussing pointless things, I’ll have
dillo fixed and uploaded in time to avoid the autoremoval.

bye,
//mirabilos
-- 
>> Why don't you use JavaScript? I also don't like enabling JavaScript in
> Because I use lynx as browser.
+1
	-- Octavio Alvarez, me and ⡍⠁⠗⠊⠕ (Mario Lang) on debian-devel


--%--
From: rodarima
Date: Mon, 05 Aug 2024 22:01:04 +0000

@mirabilos I locked the issue, but I will keep it open util the RC problem is solved so I don't forget.

@ArrayBolt3 mirabilos is going to address the RC build problem. Pressing the maintainers is not gonna change their lack of trust about updating to 3.1.1. Let's leave them some time to study the changes, and see what they decide.

--%--
From: rodarima
Date: Fri, 09 Aug 2024 11:36:52 +0000

Fixed by mirabilos in 3.0.5-7.1, closing.