Title: Dillo developers, please don't ask literally the entire Fediverse for someone to take over the Dillo Debian package when the maintainer is still around.
Author: ArrayBolt3
Created: Mon, 05 Aug 2024 22:40:23 +0000
State: closed

Continuation of https://github.com/dillo-browser/dillo/issues/230 since it was locked before I had a chance to reply and bring up the shortcomings that led to the mess there.

Why did the Dillo developers make a post on Mastodon asking for someone to adopt the Debian package for Dillo? Why was there not ample time left for the maintainer to respond before asking the entire Fediverse if someone could take over the package?

The entire time I've been interacting in https://github.com/dillo-browser/dillo/issues/230, I've been under the impression that Dillo is abandoned in Debian. Between the appearance of multiple external helpers and Debian Developers, and the actions of the Dillo developers here, I had no way of knowing the maintainer was in this conversation short of checking to see if anyone in the conversation happened to be listed as the maintainer in the Dillo Debian packaging code (which I did not do because I thought the maintainer was gone). I had no idea xtaran was the maintainer of Dillo in Debian until mirabilos's reply.

This should have been handled by contacting the maintainer *first* and giving him ample time to reply before asking for external help. As it is, y'all made it sound like Dillo was on the chopping block in Debian and no one except an external volunteer could save it from certain death. I took (scarce and valuable) time out of my life to try to save it because I find Dillo valuable, only to discover my help is not needed, not wanted, and now even considered potentially malicious. If I was the one to get this whole thread started, I can see this being a valid concern, but given the fact that the Dillo developers literally *lured* me into coming here with a cry for help, I feel like this is unwarranted.

I would suggest whoever is in charge of the Mastodon account for Dillo read through https://github.com/dillo-browser/dillo/issues/230 to see the results, and take these events under account in the future before making any post on behalf of the Dillo development team. This has stolen many hours from me, hours I would have much rather preferred spending working on any one of the other open-source projects I'm involved in. It's taken time from johnraff too, It made xtaran have to deal with what appears to be a sudden effort to take over a package he maintains, something I would find deeply frustrating and alarming were I in his position. It's left multiple people angry, and it even roped in a random Debian Developer who doesn't seem to even be related to Dillo into the picture.

As for the answers to mirabilos' questions in their last post:

1. Perfect. Then there's no further action needed from me.
2. I was unable to see what exactly you were doing with fixing a build failure. I saw one somewhat confusing comment by @rodarima about fixing the build failure (in what version of Dillo, I did not know), and the toot they linked to 404s for me and at least one other person. Additionally my Mastodon server didn't let me see any activity you had in the thread, I had to look at a different server to see that.
3. Agreed. So why did the Dillo Mastodon account call for people to come take over the package when the maintainer was here? "Is there a Debian maintainer who could help us by adopting it?" is *very* strong wording, explicitly asking someone to take over the package. This is entirely inappropriate since the maintainer is here.
4. Makes sense.

> Why are you trying to pressure him so much about this?

I had no idea he was the maintainer. I thought he was just another random DD who showed up here, probably from Mastodon or perhaps from GitLab (which is where Mechtilde came over here from).

> *Are* you, perchance, a Jia Tan?

Again, if I had started this thread, I can see this being a very valid concern. I didn't, I came over here in response to an explicit request for someone to adopt the package.

You and anyone else can feel free to Google my account name or full name to see who I am and what I do. I have MOTU upload rights into the Ubuntu repositories (meaning I can change anything in the Universe and Multiverse repositories by myself in the development release). If I was interested in compromising things I'd be able to do it without having to interact with the Dillo team or Debian at all.

> We’ve already stated in the thread around ... what’s happening, how to proceed, etc. and what not to do.

GitHub conveniently mangled the link you put here so I have no good way of knowing what you're referencing.

> I fully expect this discussion to finish here right now. Those not involved with the new Dillo project should, please, just shut up

I do not know if you're a Dillo developer or not. If you're not, this is rather uncalled for given how this thread got started. If you are, this is infuriating to say after *your own team* asked for people to come get involved. If you want to push away potential helpers or maintainers, this is the quickest and easiest way to do it. I will not be contributing to Dillo in the foreseeable future after this and will likely actively avoid attempts to contribute to it now that I've been through this mess.

--%--
From: rodarima
Date: Tue, 06 Aug 2024 00:18:44 +0000

> Why did the Dillo developers make a post on Mastodon asking for someone to adopt the Debian package for Dillo? Why was there not ample time left for the maintainer to respond before asking the entire Fediverse if someone could take over the package?

The reason I asked on Fedi is because I was under the impression the package was abandoned in Debian.

> This should have been handled by contacting the maintainer first and giving him ample time to reply before asking for external help. 

I have emailed the maintaner in April, May and June about my intentions to update the package to this upstream:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1022726

Although the maintaner replied privately to me on Fedi in April that he would try to look into it, I did not see any other news on the bug tracker.

I learnt how to prepare a Debian package and made one myself (I'm not a Debian user or developer), which I proposed in their salsa repo, although I'm sure it was not very good I did my best:

https://salsa.debian.org/debian/dillo/-/merge_requests/1

But I got no feedback.

When I saw the RC bug, I assumed it will be taken down from the Debian repositories before it gets fixed. After two weeks of no changes, I decided to ask for help in case someone can help with maintanership.

It was not my intention to do any hostile takeover, but to cooperate with the current maintainer to update the package to 3.1.1 (which would also fix the RC bug).

> The entire time I've been interacting in https://github.com/dillo-browser/dillo/issues/230, I've been under the impression that Dillo is abandoned in Debian

That was my impression too in sight of the previous events.

> I took (scarce and valuable) time out of my life to try to save it because I find Dillo valuable, only to discover my help is not needed, not wanted, and now even considered potentially malicious.

When I asked for help, I had no idea that one of the problems to update Dillo is the lack of trust on this upstream (which is understandable) which [was reported yesterday](https://fosstodon.org/@xtaran@chaos.social/112905124967939203). So I assumed that help from other maintainers would be appreciated, as I understood the maintaner was busy.

>> Why are you trying to pressure him so much about this?
>
> I had no idea he was the maintainer.

Sorry, I should have provided a summary of the situation in the issue.

> I do not know if you're a Dillo developer or not. If you're not, this is rather uncalled for given how this thread got started. If you are, this is infuriating to say after your own team asked for people to come get involved. If you want to push away potential helpers or maintainers, this is the quickest and easiest way to do it. I will not be contributing to Dillo in the foreseeable future after this and will likely actively avoid attempts to contribute to it now that I've been through this mess.

Mirabilos seems to be a Debian maintainer that jumped to fix the RC problem by patching the 3.0.5 version, but I have not seen any other contribution to Dillo code from that user.

The misunderstanding is my fault, as I should have provided more information before reaching that point.

Keep in mind that I would like for Dillo to be updated in Debian, but my main focus is maintaining Dillo itself, which is not an easy task at all that I'm also doing on my free time. There is no need to actively try to harm the project, it was already pretty dead on its own, and I was just trying to avoid it from dissapearing. See:

https://news.ycombinator.com/item?id=38847613

--%--
From: ArrayBolt3
Date: Tue, 06 Aug 2024 00:34:21 +0000

Thanks, this helps clear up a lot of things.

For what it's worth, I wasn't trying to harm the project. That paragraph is just me expressing that this was painful enough that I don't want to be a contributor. It felt bad to be accused of potential malicious activity (not by you of course) when I had come to help, and it left a sour enough taste in my mouth I just would rather spend my time elsewhere. (I also had the awkward situation of having no idea what was happening with mirabilos or the rest of the exchange on Mastodon because my server apparently is glitchy and didn't show me any of the other conversations - all of mirabilos's and xtaran's toots don't show up for me unless I view them from a different Mastodon server.)

--%--
From: ArrayBolt3
Date: Tue, 06 Aug 2024 00:51:58 +0000

Also, I'm sorry for how upset I was above. I didn't have context, nor did I realize that the Dillo team was mostly you working on it. I sincerely want the project to succeed, just the hostile message mirabilos directed mostly at me hurt, and I didn't understand how things went down the path they did. I wish you and the Dillo project the best, and will try to stay out of everyone's way so that I don't cause or prolong any other problems on accident.

--%--
From: johnraff
Date: Tue, 06 Aug 2024 06:40:36 +0000

Since the original thread is locked, I'll just add here that I was also taken aback by the tone of @mirabilos 's last post, where he walked into the room like a teacher addressing a group of noisy schoolchildren.

It seems there were multiple misunderstandings all round. 

While I knew @xtaran was the dillo maintainer and that @rodarima had tried to contact him, also posting on a related Debian [bug report](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1022726) where xtaran said "...also in the long run to me maybe remove Dillo from Debian". It's also true that he is very busy on multiple other tasks - his name appears often - so it might have been reasonable to think he was prepared to allow dillo to be dropped. I now realise that's not the case. 

I also had no knowlege of the discussions taking place on Mastodon about fixing the GCC-14 issue, or mirabilos's explanation of "what’s happening, how to proceed, etc. and what not to do". The links do not open except by a circuitous process of logging in to one's own Mastodon server, then trying to find the post...

Anyway, I think this is inappropriate for a forum where everyone is trying to help:
> I fully expect this discussion to finish here right now.
Those not involved with the new Dillo project should, please,
just shut up...

---
I'd just like to mention one other issue with the current dillo 3.0.5 as it is in Debian, is that it cannot display a number of websites, including Debian's own, due to outdated TLS support. That is fixed in both @rodarima 's and @w00fpack 's dillo upgrades, and might well be easily patchable without shifting to another upstream source for the code body.

Anyway, @rodarima thank you for your work on dillo, which I have long been fond of and intend to keep packaging for [BunsenLabs](https://github.com/BunsenLabs), at least until the Debian package has caught up a bit.



--%--
From: rodarima
Date: Tue, 06 Aug 2024 10:09:32 +0000

> Also, I'm sorry for how upset I was above. I didn't have context, nor did I realize that the Dillo team was mostly you working on it. I sincerely want the project to succeed, just the hostile message mirabilos directed mostly at me hurt, and I didn't understand how things went down the path they did. I wish you and the Dillo project the best, and will try to stay out of everyone's way so that I don't cause or prolong any other problems on accident.

Thanks!, I'll try to be more clear when addressing this issue in the future to prevent more misunderstandings.

> I also had no knowlege of the discussions taking place on Mastodon about fixing the GCC-14 issue, or mirabilos's explanation of "what’s happening, how to proceed, etc. and what not to do". The links do not open except by a circuitous process of logging in to one's own Mastodon server, then trying to find the post...

I tried to make the thread publicly available, but the web archive doesn't seem to be able to index it either. I could take a long screenshot but I'm not sure if that would be appropriate under Mastodon policies.

> I'd just like to mention one other issue with the current dillo 3.0.5 as it is in Debian, is that it cannot display a number of websites, including Debian's own, due to outdated TLS support.

Yeah, there are several problems with 3.0.5. At that time the support for HTTPs was experimental and was implemented in a plugin, which had several shortcomings.

https://github.com/dillo-browser/dillo/blob/v3.0.5/dpi/https.c#L34-L44

https://github.com/dillo-browser/dillo/blob/84196030146a30110ba53c86d1e1fed156b2359e/dpi/https.c#L34-L44

I could enumerate one by one all the problems with the 3.0.5 version, and point out how they are fixed either by the original developers in the commits after 3.0.5, or in my own fixes. But that would take a non-negligible amount of time, so I'll wait and see if they become evident on their own.

In the meanwhile, if all concerns were addressed, please @ArrayBolt3 feel free to close this issue.

--%--
From: mirabilos
Date: Tue, 06 Aug 2024 14:11:17 +0000

> Continuation of #230 since it was locked

Aaaaaaargh!

I’m out here. I don’t have the time to bother even reading this thread.

--%--
From: johnraff
Date: Wed, 07 Aug 2024 01:28:27 +0000

@mirabilos please take it easy.

Your comments on Mastodon all look reasonable, and I think it would not hurt to show a more friendly attitude to people here, who mean the best for dillo, for Debian and for Linux users.



--%--
From: mirabilos
Date: Wed, 07 Aug 2024 09:05:25 +0000

Kindly stop @-ing me after I have **explicitly** said I don’t have the nerve to discuss this here and unsubscribed. 🤬

--%--
From: xtaran
Date: Wed, 07 Aug 2024 09:36:00 +0000

> While I knew @xtaran was the dillo maintainer and that @rodarima had tried to contact him, also posting on a related Debian [bug report](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=10227269)

It's [#1022726](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1022726), not #10227269

>  where xtaran said "...also in the long run to me maybe remove Dillo from Debian".

Please don't quote me out of context. This quote is from a time where I neither was aware of https://github.com/w00fpack/dilloNG/ nor of https://github.com/dillo-browser/dillo/ and hence neither reflects the current state nor intentions. (Yes I became aware of  https://github.com/w00fpack/dilloNG/ shortly afterwards, but Debian bug reports are append-only respectively already existing entries are immutable.)

--%--
From: johnraff
Date: Thu, 08 Aug 2024 05:29:29 +0000

> > While I knew @xtaran was the dillo maintainer and that @rodarima had tried to contact him, also posting on a related Debian [bug report](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=10227269)
> 
> It's [#1022726](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1022726), not #10227269

Thanks for catching that.
 
> > where xtaran said "...also in the long run to me maybe remove Dillo from Debian".
> 
> Please don't quote me out of context. This quote is from a time where I neither was aware of https://github.com/w00fpack/dilloNG/ nor of https://github.com/dillo-browser/dillo/ and hence neither reflects the current state nor intentions.

I'm sorry - I was not clear enough in my language. It's true that the following day you mentioned other contributors' code as looking "sane", and I should have paid more attention to that. Anyway, I now understand that you have no intention of dropping dillo, which is great news as far as I'm concerned.

I never had any intention of pressuring you - or anyone else - but having been CC'd to the original thread, thought my Debianization of dillo-browser's current 3.1.1 might have useful snippets and save someone some time somewhere.

