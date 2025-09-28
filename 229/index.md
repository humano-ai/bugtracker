Title: magnet: link plugin
Author: rakoo
Created: Fri, 19 Jul 2024 02:36:19 +0000
State: open

Hey there, thanks for dillo it's nice to see it alive and well !

I made a plugin for `magnet:` links: https://sr.ht/~rakoo/dillo-plugin-magnet/. It is pretty naive and straightforward, made mostly to understand how this whole thing feels; I plan to add other protocols and semi-apps in the future. That thing is amazing !

--%--
From: rodarima
Date: Fri, 19 Jul 2024 17:37:06 +0000

> Hey there, thanks for dillo it's nice to see it alive and well !
>
> I made a plugin for `magnet:` links: https://sr.ht/~rakoo/dillo-plugin-magnet/. It is pretty naive and straightforward, made mostly to understand how this whole thing feels; I plan to add other protocols and semi-apps in the future. That thing is amazing !

Very nice :-)

I tested it and it seems to work fine after some time, for some reason aria2c takes a while in my computer.

I recommend you add a Makefile so people only have to do a `make install` command, regardless of the language you use. Example: https://github.com/dillo-browser/dillo-plugin-ipfs/blob/master/Makefile

--%--
From: rakoo
Date: Fri, 19 Jul 2024 18:22:21 +0000

Thank you :)

There's no magic: aria2c takes a while because it has to find peers that share the given swarm before downloading from them. Once found, they tend to be fast though.

This exhibits another problem: what if an external process is slow ? From dpi's point of view another tag can be sent, so it should be interceptable. For example a DpiBye should kill not just the filter but also all sub-processes. Right ?

The Makefile is a really nice idea, I will add that !


--%--
From: rodarima
Date: Thu, 25 Jul 2024 19:56:12 +0000

Hi,

>There's no magic: aria2c takes a while because it has to find peers 
>that share the given swarm before downloading from them. Once found, 
>they tend to be fast though.

I'm using this one:

   magnet:?xt=urn:btih:0cd42065571809961e9661db2123a87d77c33964&dn=archlinux-2024.07.01-x86_64.iso

For me it takes around 30 seconds to fetch the .torrent file, while if I 
open it in qbittorrent it goes very quickly, in less than 500 ms. Not 
sure if qb has some swarm already cached somewhere or NAT hole punching 
or some other technique to increase the speed.

>This exhibits another problem: what if an external process is slow ? 
>From dpi's point of view another tag can be sent, so it should be 
>interceptable. For example a DpiBye should kill not just the filter but 
>also all sub-processes. Right ?

You can make the plugin as a "server" type, instead of just a filter, 
see:

https://dillo-browser.github.io/user_help.html#plugins

This way you can start the plugin on the first magnet request and leave 
it running so subsequent requests are faster.

And yes, the DpiBye should kill all processes spawned by the plugin.


--%--
From: rakoo
Date: Fri, 26 Jul 2024 15:36:27 +0000

rodarima ***@***.***> wrote:
> I'm using this one:
> 
>    magnet:?xt=urn:btih:0cd42065571809961e9661db2123a87d77c33964&dn=archlinux-2024.07.01-x86_64.iso
> 
> For me it takes around 30 seconds to fetch the .torrent file, while if I 
> open it in qbittorrent it goes very quickly, in less than 500 ms. Not 
> sure if qb has some swarm already cached somewhere or NAT hole punching 
> or some other technique to increase the speed.

If you let qbittorrent run continuously then it probably has a
more accurate routing table, so querying is definitely going to
be faster. That's another argument for letting the dpi run
continuously in the background

> You can make the plugin as a "server" type, instead of just a filter, 
> see:
> 
> https://dillo-browser.github.io/user_help.html#plugins
> 
> This way you can start the plugin on the first magnet request and leave 
> it running so subsequent requests are faster.

Indeed, I need to switch to that. I just didn't see an easy-to-grasp
server dpi (and the facility provided by the go lib didn't seem to
work, but I need to try again)

> And yes, the DpiBye should kill all processes spawned by the plugin.

Good. In server mode does that also mean that the server should die ?

-- 
Matthieu Rakotojaona


--%--
From: rodarima
Date: Fri, 26 Jul 2024 20:31:41 +0000

Hi,

>If you let qbittorrent run continuously then it probably has a
>more accurate routing table, so querying is definitely going to
>be faster. That's another argument for letting the dpi run
>continuously in the background

The test was done by opening qbittorrent for the first time in the day.

Out of curiosity, I did another test where I open qbittorrent from a new
user, so it is the first time ever it is opened, and it also is able to
load the metadata in less than a few seconds.

For some reason I cannot just open qbittorrent with the magnet for the
first time as an argument otherwise it gets stuck forever (likely a
bug), so I make it sleep for two seconds before adding the magnet to
download:

$ ssh -X ***@***.*** 'rm -rf ~/.{config,cache,local}; \
   qbittorrent &; \
   sleep 2; \
   qbittorrent "magnet:?xt=urn:btih:0cd42065571809961e9661db2123a87d77c33964&dn=archlinux-2024.07.01-x86_64.iso"'

I also verified with strace that is reading the data from /home/guest
rather than my normal user.

So I don't think it is because qbittorrent has some information saved on 
on disk, but I think it has some other search mechanism to query magnets
which is much faster than aria2c.

I tried with transmission too, but it is also very slow.

>> You can make the plugin as a "server" type, instead of just a filter,
>> see:
>>
>> https://dillo-browser.github.io/user_help.html#plugins
>>
>> This way you can start the plugin on the first magnet request and leave
>> it running so subsequent requests are faster.
>
>Indeed, I need to switch to that. I just didn't see an easy-to-grasp
>server dpi (and the facility provided by the go lib didn't seem to
>work, but I need to try again)

Here is an example of a Go server plugin written by Charles E. Lehner
for IPFS:

https://github.com/dillo-browser/dillo-plugin-ipfs

Inside Dillo itself you can also find some server plugins (the ones that
don't have "filter" in the name):

https://github.com/dillo-browser/dillo/blob/master/dpi/Makefile.am#L48-L55

>
>> And yes, the DpiBye should kill all processes spawned by the plugin.
>
>Good. In server mode does that also mean that the server should die ?

Yes, the server plugin should exit the main loop. Here is an example for
the file plugin:

https://github.com/dillo-browser/dillo/blob/master/dpi/file.c#L1097
