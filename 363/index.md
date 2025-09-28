Title: dillo 3.2 release on irix 6.5.21+
Author: Sunny-Maxis
Created: Tue, 04 Mar 2025 05:47:44 +0000
State: open

Hello everyone, 

I am under the employ of Kazuo Kuroi (owner of IRIXNet) and trying to test if dillo can be built on IRIX. 

Here is my analysis and work thus far:

Firstly, all C++ dependencies must be built with GCC. This is due to incompatible C++ ABI (and because Mipspro does not support variadic macros)

As far as building it goes, we had a couple of hiccups from bad headers. Kazuo observed that the stat64 struct pissed off our GCC 6.5.0 requiring us to patch the header temporarily although we will probably be able to fix include in GCC if necessary. 

As far as building, we got to the final link stage:

/opt/gcc/bin/g++ -I/usr/nekoware/include/libpng16 -I/usr/nekoware/include -I/usr/nekoware/include/freetype2 -I/usr/nekoware/include/libpng16 -I/usr/nekoware/include -O2 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_THREAD_SAFE -D_REENTRANT -g -O2 -Wall -W -Wno-unused-parameter -fno-rtti -fno-exceptions -pedantic -std=c++11 -D_POSIX_C_SOURCE=200112L  -L/usr/nekoware/gcc/lib32 -Wl,-rpath -L/usr/nekoware/lib32 -L/usr/lib32 -Wl,/usr/nekoware/gcc/lib32 -lxg -lgen -o dillo dillo.o version.o paths.o tipwin.o ui.o uicmd.o bw.o cookies.o actions.o hsts.o auth.o md5.o digest.o colors.o misc.o history.o prefs.o prefsparser.o keys.o url.o bitvec.o klist.o chain.o utf8.o timeout.o dialog.o web.o nav.o cache.o decode.o dicache.o capi.o domain.o css.o cssparser.o styleengine.o plain.o html.o form.o table.o bookmark.o dns.o gif.o jpeg.o png.o webp.o svg.o imgbuf.o image.o menu.o dpiapi.o findbar.o xembed.o  ../dlib/libDlib.a ../dpip/libDpip.a IO/libDiof.a ../dw/libDw-widgets.a ../dw/libDw-fltk.a ../dw/libDw-core.a ../lout/liblout.a -ljpeg -L/usr/nekoware/lib32 -lpng16 -lwebp -L/usr/nekoware/lib32 -Wl,-rpath,/usr/nekoware/lib32 -L/usr/lib32 -Wl,-rpath -Wl,/usr/nekoware/lib32 -lfltk -lXrender -lXext -lfontconfig -lpthread -lm -lX11 -lz -liconv   -lcrypto -lssl 
/usr/nekoware/lib32/libxg.so: undefined reference to `dirfd'
/usr/nekoware/lib32/libXrender.so: undefined reference to `_XEatDataWords'

We are not 100% sure what is causing the error with libxrender. That's something that will need to be diagnosed further. It might be a C++ name mangling issue or something 

Ignoring the error with libxg (a library built by Kazuo to offer setenv on IRIX, here's the summary of work to maintain IRIX support in tree:

In dpi.c you should not include netinet/tcp.h with the __sgi macro guarding it out. Instead, manually define TCP_NODELAY with 0x01

Make sure configure checks if on irix you're using GCC. Mipspro probably will never build unless you got rid of all variadic macros and ditched a move to C++11, so as that's infeasible/impractical, just make sure that GCC is the actual compiler being used. 

menu.cc should have a compat for setenv(). That is why we pulled in libxg (libxenograft) but it should not be relied on as not everybody is using this compatibility library. We are hardly the only platform with out this set of functionality. 

That's all there is to it. Everything else about our issues linking and building it at this point should be fixable on our end soon. We are using a messy tool chain and a messy set of dependencies that might be causing some of our problems. Fix these issues, and I wouldn't be surprised if it builds on most ancient SVR4 systems with little pain. 

I will be happy to submit a pull request to fix some of these problems when I have more information in front of me but I need to figure out how to add setenv() to this if that duty falls to me (honestly I would prefer you guys to just incorporate it in a way that's not going to hurt you) 

Best regards,

Patrick "Sunny" Maxis

--%--
From: rodarima
Date: Tue, 04 Mar 2025 20:13:57 +0000

> Hello everyone,
> 
> I am under the employ of Kazuo Kuroi (owner of IRIXNet) and trying to test if dillo can be built on IRIX.
> 
> Here is my analysis and work thus far:
> 
> Firstly, all C++ dependencies must be built with GCC. This is due to incompatible C++ ABI (and because Mipspro does not support variadic macros)

I think we could drop the variadic macros, but not sure if it is worth the hassle. Maybe I can leave this for later as it seems GCC is a way to avoid this for now.

> As far as building it goes, we had a couple of hiccups from bad headers. Kazuo observed that the stat64 struct pissed off our GCC 6.5.0 requiring us to patch the header temporarily although we will probably be able to fix include in GCC if necessary.
> 
> As far as building, we got to the final link stage:
> 
> /opt/gcc/bin/g++ -I/usr/nekoware/include/libpng16 -I/usr/nekoware/include -I/usr/nekoware/include/freetype2 -I/usr/nekoware/include/libpng16 -I/usr/nekoware/include -O2 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_THREAD_SAFE -D_REENTRANT -g -O2 -Wall -W -Wno-unused-parameter -fno-rtti -fno-exceptions -pedantic -std=c++11 -D_POSIX_C_SOURCE=200112L -L/usr/nekoware/gcc/lib32 -Wl,-rpath -L/usr/nekoware/lib32 -L/usr/lib32 -Wl,/usr/nekoware/gcc/lib32 -lxg -lgen -o dillo dillo.o version.o paths.o tipwin.o ui.o uicmd.o bw.o cookies.o actions.o hsts.o auth.o md5.o digest.o colors.o misc.o history.o prefs.o prefsparser.o keys.o url.o bitvec.o klist.o chain.o utf8.o timeout.o dialog.o web.o nav.o cache.o decode.o dicache.o capi.o domain.o css.o cssparser.o styleengine.o plain.o html.o form.o table.o bookmark.o dns.o gif.o jpeg.o png.o webp.o svg.o imgbuf.o image.o menu.o dpiapi.o findbar.o xembed.o ../dlib/libDlib.a ../dpip/libDpip.a IO/libDiof.a ../dw/libDw-widgets.a ../dw/libDw-fltk.a ../dw/libDw-core.a ../lout/liblout.a -ljpeg -L/usr/nekoware/lib32 -lpng16 -lwebp -L/usr/nekoware/lib32 -Wl,-rpath,/usr/nekoware/lib32 -L/usr/lib32 -Wl,-rpath -Wl,/usr/nekoware/lib32 -lfltk -lXrender -lXext -lfontconfig -lpthread -lm -lX11 -lz -liconv -lcrypto -lssl
/usr/nekoware/lib32/libxg.so: undefined reference to 'dirfd'
/usr/nekoware/lib32/libXrender.so: undefined reference to '_XEatDataWords'
> 
> We are not 100% sure what is causing the error with libxrender. That's something that will need to be diagnosed further. It might be a C++ name mangling issue or something

Regarding:

> /usr/nekoware/lib32/libXrender.so: undefined reference to '_XEatDataWords'

In my system (Arch Linux) libXrender.so requires the symbol _XEatDataWords which is provided by needed shared library libX11.so.6 in the ELF header of libXrender.so:

```
% readelf -Ws /usr/lib/libXrender.so | grep _XEatDataWords
    40: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND _XEatDataWords

% readelf -d /usr/lib/libXrender.so

Dynamic section at offset 0x9c80 contains 26 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [libX11.so.6]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
 0x000000000000000e (SONAME)             Library soname: [libXrender.so.1]
 0x000000000000000c (INIT)               0x2000
 0x000000000000000d (FINI)               0x8564
 0x0000000000000019 (INIT_ARRAY)         0xac70
 0x000000000000001b (INIT_ARRAYSZ)       8 (bytes)
 0x000000000000001a (FINI_ARRAY)         0xac78
 0x000000000000001c (FINI_ARRAYSZ)       8 (bytes)
 0x000000006ffffef5 (GNU_HASH)           0x310
 0x0000000000000005 (STRTAB)             0xd60
 0x0000000000000006 (SYMTAB)             0x508
 0x000000000000000a (STRSZ)              1663 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000007 (RELA)               0x14e8
 0x0000000000000008 (RELASZ)             1128 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x000000000000001e (FLAGS)              BIND_NOW
 0x000000006ffffffb (FLAGS_1)            Flags: NOW
 0x000000006ffffffe (VERNEED)            0x1498
 0x000000006fffffff (VERNEEDNUM)         1
 0x000000006ffffff0 (VERSYM)             0x13e0
 0x0000000000000024 (RELR)               0x1950
 0x0000000000000023 (RELRSZ)             24 (bytes)
 0x0000000000000025 (RELRENT)            8 (bytes)
 0x0000000000000000 (NULL)               0x0

% readelf -Ws /usr/lib/libX11.so | grep _XEatDataWords
   829: 0000000000017584    93 FUNC    GLOBAL DEFAULT    9 _XEatDataWords
```

Does your libX11.so provide it? This simple test isolates any potential problem from mangling:

```
% cat a.c
void _XEatDataWords(void);

int main()
{
	_XEatDataWords();
	return 0;
}
% gcc a.c -o a -lXrender
/usr/bin/ld: /tmp/cc0TaBie.o: undefined reference to symbol '_XEatDataWords'
/usr/bin/ld: /usr/lib/libX11.so.6: error adding symbols: DSO missing from command line
collect2: error: ld returned 1 exit status
% gcc a.c -o a -lXrender -lX11
% gcc a.c -o a -lX11 -lXrender
```

> Ignoring the error with libxg (a library built by Kazuo to offer setenv on IRIX, here's the summary of work to maintain IRIX support in tree:
> 
> In dpi.c you should not include netinet/tcp.h with the __sgi macro guarding it out. Instead, manually define TCP_NODELAY with 0x01

I think this could be tested at configure time and set a HAVE_TCP_NODELAY or similar, so we don't need to rely on __sgi directly.

> Make sure configure checks if on irix you're using GCC. Mipspro probably will never build unless you got rid of all variadic macros and ditched a move to C++11, so as that's infeasible/impractical, just make sure that GCC is the actual compiler being used.

Maybe we can just add a check for variadic macros at configure time as well? This may fail on other compilers as well.

> menu.cc should have a compat for setenv(). That is why we pulled in libxg (libxenograft) but it should not be relied on as not everybody is using this compatibility library. We are hardly the only platform with out this set of functionality.

Do you have putenv()? We can make a compatibility implementation if not found at configure time.

> That's all there is to it. Everything else about our issues linking and building it at this point should be fixable on our end soon. We are using a messy tool chain and a messy set of dependencies that might be causing some of our problems. Fix these issues, and I wouldn't be surprised if it builds on most ancient SVR4 systems with little pain.

That's actually not that bad :-)

> I will be happy to submit a pull request to fix some of these problems when I have more information in front of me but I need to figure out how to add setenv() to this if that duty falls to me (honestly I would prefer you guys to just incorporate it in a way that's not going to hurt you)

I can prepare some patches, but it would be nice if you can test them on IRIX. Also, if you manage to run it, I would like to add a screenshot and/or picture to the gallery: https://dillo-browser.github.io/gallery/index.html

--%--
From: rodarima
Date: Tue, 04 Mar 2025 23:11:26 +0000

Regarding

> > In dpi.c you should not include netinet/tcp.h with the __sgi macro guarding it out. Instead, manually define TCP_NODELAY with 0x01
> 
> I think this could be tested at configure time and set a HAVE_TCP_NODELAY or similar, so we don't need to rely on __sgi directly.

Is `netinet/tcp.h` missing in your specific version of IRIX?, or is just not defining TCP_NODELAY?.

This IRIX manual I could find online seems to suggest that it must be defined in `netinet/tcp.h`:

https://nixdoc.net/man-pages/IRIX/man7/tcp.7.html

```
     TCP supports two socket options which can be tested with getsockopt(2),
     and manipulated with setsockopt(2).  These	options	are defined in
     <netinet/tcp.h>.

     TCP_NODELAY
	  Under	most circumstances, TCP	sends data when	it is presented; when
	  outstanding data has not yet been acknowledged, it gathers small
	  amounts of output to be sent in a single packet once an
	  acknowledgement is received.	For a small number of clients, such as
	  window systems that send a stream of mouse events which receive no
	  replies, this	packetization may cause	significant delays.
	  Therefore, TCP provides a boolean option, TCP_NODELAY, to defeat
	  this algorithm.
```

If it is missing, is `TCP_NODELAY` defined elsewhere, so we can include that header instead? It would be nice if I can get a copy of the headers so I can see how things are defined in IRIX.

Otherwise, how can we know it has value 0x01 and it is supported?

Another way is to avoid the `setsockopt()` when TCP_NODELAY is not defined, as it is only used to improve the performance while communicating with the plugins via localhost, so we assume that it is not supported.

Here is a curl patch that does that when not defined:

https://curl.se/mail/lib-2004-03/0340.html

--%--
From: Sunny-Maxis
Date: Wed, 05 Mar 2025 03:55:22 +0000

> I think we could drop the variadic macros, but not sure if it is worth the hassle. Maybe I can leave this for later as it seems GCC is a way to avoid this for now.

It's definitely a portability problem if you want portability with ancient compilers. 

> Does your libX11.so provide it?

We failed that test because we don't have Xrender in base. We also cannot recompile our X stuff, as we use XSGI. I will have to see if an older version of libXrender gets around this issue. Or else rewrite our implementation. I figured it was something to do with GNU ld which is a giant issue on our platform for various reasons. It tends to break in very unpredictable ways. 

Either way I thank you for pointing that out regardless because I would not have picked up on that. 

We managed to correct that issue by updating our libXrender code to not define it. 

> I think this could be tested at configure time and set a HAVE_TCP_NODELAY or similar, so we don't need to rely on __sgi directly.

The issue more so is that our base header is a problem.  Some headers on IRIX are not GCC-safe and I can't necessarily test your program with mipspro unless you really want to strip away anything super problematic to it's c99 compiler. Genuinely don't think that that's worth our time either way unless you really want to commit to it. 
Trust me when I say this is an SGI specific problem. You need to guard the header and manually define it. I'm not going to start patching headers against it it's not something that's worth doing for a variety of reasons. 

> Is netinet/tcp.h missing in your specific version of IRIX?, or is just not defining TCP_NODELAY?.

The header literally chokes GCC out. Here's the actual error and there's only really very little I can do except for probably try to build a fixinclude for it (we are using an unofficial GCC 6 build) 

https://pastebin.com/MLA5dyuV

The problem primarily is that some of these headers are system headers and they're not intended for use by GCC, which is a guest compiler, on our system. So the easiest way to fix this is to just manually define it for our platform specifically. There are no other versions of IRIX that are probably going to be running this. 

> Do you have putenv()? We can make a compatibility implementation if not found at configure time.

That would be acceptable yes. 

> I can prepare some patches, but it would be nice if you can test them on IRIX

Me and the boss are willing to do our best about tracking you guys and reporting issues as they come up as well as offering patches. But we can't make exact time guarantees

--%--
From: rodarima
Date: Wed, 05 Mar 2025 20:05:43 +0000

> Either way I thank you for pointing that out regardless because I would not have picked up on that.
> 
> We managed to correct that issue by updating our libXrender code to not define it.

Nice!

> > I think this could be tested at configure time and set a HAVE_TCP_NODELAY or similar, so we don't need to rely on __sgi directly.
> 
> The issue more so is that our base header is a problem. Some headers on IRIX are not GCC-safe and I can't necessarily test your program with mipspro unless you really want to strip away anything super problematic to it's c99 compiler. Genuinely don't think that that's worth our time either way unless you really want to commit to it. Trust me when I say this is an SGI specific problem. You need to guard the header and manually define it. I'm not going to start patching headers against it it's not something that's worth doing for a variety of reasons.
> 
> > Is netinet/tcp.h missing in your specific version of IRIX?, or is just not defining TCP_NODELAY?.
> 
> The header literally chokes GCC out. Here's the actual error and there's only really very little I can do except for probably try to build a fixinclude for it (we are using an unofficial GCC 6 build)
> 
> https://pastebin.com/MLA5dyuV
> 
> The problem primarily is that some of these headers are system headers and they're not intended for use by GCC, which is a guest compiler, on our system. So the easiest way to fix this is to just manually define it for our platform specifically. There are no other versions of IRIX that are probably going to be running this.

I see. I have added the fix you suggest, but I would like to explore a better solution as it looks like a very brittle workaround (for example if we use another define it would break if we don't define it manually as well).

From those logs it looks like the only problem is that u_short and u_char are not defined. This may be just a case in which netinet/tcp.h needs those types being defined before it is included.

Could you provide the output of this? (on /usr/include or where the headers are located in IRIX):

```
$ grep -R 'typedef.* u_char' /usr/include
```

In my system, they seem to be defined at sys/types.h, so I imagine something like this would work:

```
% cat nodelay.c
#include <sys/types.h> /* u_char, u_short */
#include <netinet/tcp.h> /* TCP_NODELAY */
#include <stdio.h> /* printf */

int main()
{
	printf("TCP_NODELAY = %d\n", TCP_NODELAY);
	return 0;
}
% gcc nodelay.c -o nodelay
% ./nodelay
TCP_NODELAY = 1
```

If that is the case, we just need to include that file before netinet/tcp.h.

> > Do you have putenv()? We can make a compatibility implementation if not found at configure time.
> 
> That would be acceptable yes.

I have added an implementation, but it would be nice if you can test it as I won't be able to test if it actually works: https://github.com/dillo-browser/dillo/pull/364

--%--
From: Sunny-Maxis
Date: Wed, 05 Mar 2025 22:15:41 +0000

Ignore my past comment that I had which I just deleted. 

The setenv() fix still requires unsetenv() which we don't have either. 

I just checked. I don't have recursive grep (IRIX is SVR4, we don't use coreutils) so I ran it with find and yes the inclusion is in sys/types.h

I don't think you're understanding what the problem is exactly but it's okay, I'll illustrate:

https://pastebin.com/raw/iA2Ndtmy

This is the header in question. It's designed for mipspro. On IRIX, by default, several of the headers are separated between ANSI, C99 and C++. For instance stdint.h. this breaks a lot of stuff so when GCC comes in it just ignores all of the include guards and in some cases has fixincludes to fix the most egregious, but this is not the case for all of them. 

The problem is it's choking on the struct tcphdr. And if I were to correct it, it potentially breaks mipspro. This makes the header unusable for GCC. This is not the only place in the system this occurs, it happens with several XOPEN headers forcing you to manually pull various definitions. It's not something I can correct for because this is a proprietary operating system. We aren't like open Solaris and we can't make assumptions that people will have patched headers. 

Unfortunately this is the case with supporting older operating systems: you often have to use nasty hacks and brittle fixes. There's not a way I can understand to compromise this. A potential fix of building a fixincludes for GCC is possible but honestly it's not worth it in this case. This is the only time I've ever had this particular issue and I've built half a dozen programs with it. 

If you want to avoid having such brittle fixes directly in the line of fire, add a compat_irix header full ;f.manual definitions and hacks. This is what my boss does for libjpegturbo and a few others we fork. 

Also the proper manual definition is 0x01. It might not make a difference but I always like to copy what the actual header actually says. 

I don't know a lot of ways I can easily compromise and fix this on an our end; we are stuck in a similar situation to ArcaOS. We are applying patches and fixes to the system but we have to do so in a relatively conservative manner to avoid breaking things. There's not really a way I can just radically change stuff up. 

--%--
From: rodarima
Date: Wed, 05 Mar 2025 23:53:11 +0000

> Ignore my past comment that I had which I just deleted.
> 
> The setenv() fix still requires unsetenv() which we don't have either.

Hmm, I think we can ignore that as it will be unlikely that it is already set on the environment. Otherwise we will need to get the env pointer and do it manually. I updated the PR, let me know if that works now.

> I just checked. I don't have recursive grep (IRIX is SVR4, we don't use coreutils) so I ran it with find and yes the inclusion is in sys/types.h
> 
> I don't think you're understanding what the problem is exactly but it's okay, I'll illustrate:
> 
> https://pastebin.com/raw/iA2Ndtmy
> 
> This is the header in question. It's designed for mipspro. On IRIX, by default, several of the headers are separated between ANSI, C99 and C++. For instance stdint.h. this breaks a lot of stuff so when GCC comes in it just ignores all of the include guards and in some cases has fixincludes to fix the most egregious, but this is not the case for all of them.
> 
> The problem is it's choking on the struct tcphdr. And if I were to correct it, it potentially breaks mipspro. This makes the header unusable for GCC. This is not the only place in the system this occurs, it happens with several XOPEN headers forcing you to manually pull various definitions. It's not something I can correct for because this is a proprietary operating system. We aren't like open Solaris and we can't make assumptions that people will have patched headers.
> 
> Unfortunately this is the case with supporting older operating systems: you often have to use nasty hacks and brittle fixes. There's not a way I can understand to compromise this. A potential fix of building a fixincludes for GCC is possible but honestly it's not worth it in this case. This is the only time I've ever had this particular issue and I've built half a dozen programs with it.
> 
> If you want to avoid having such brittle fixes directly in the line of fire, add a compat_irix header full ;f.manual definitions and hacks. This is what my boss does for libjpegturbo and a few others we fork.
> 
> Also the proper manual definition is 0x01. It might not make a difference but I always like to copy what the actual header actually says.


Thanks for the extra details, it makes it more clear.

I understand it is not viable to modify the headers. My suggestion is to pre-define some types from Dillo source *before* we include the netinet/tcp.h file so it works on GCC as-is.

If the only two types missing are u_char and u_short (and based on your build errors it looks like it is so), we could do this:

```
typedef unsigned char u_char;
typedef unsigned short u_short;
#include <netinet/tcp.h> /* TCP_NODELAY */
#include <stdio.h> /* printf */

int main()
{
	printf("TCP_NODELAY = %d\n", TCP_NODELAY);
	return 0;
}
```

And it will compile fine. If you can test this, I can update the PR with these typedefs for IRIX.

Based on your log, there doesn't seem to be any other error.

I did a test on my system to check if that may work and it seems that it does.

---

First I copied your netinet/tcp.h header as-is in ./netinet/tcp.h and added some dummy headers to fill the missing definitions that your IRIX system seems to provide in sgidefs.h and sys/endian.h (or other included files by those):

```
% find
.
./netinet
./netinet/tcp.h
./sgidefs.h
./sys
./sys/endian.h
./nodelay.c

% cat sys/endian.h
#define _LITTLE_ENDIAN	'L'
#define _BIG_ENDIAN	'B'
#define _BYTE_ORDER _BIG_ENDIAN

% cat sgidefs.h
typedef unsigned int __uint32_t;
```

Then I added those typedefs with a guard I can enable or disable from the command line:

```
% cat nodelay.c
#ifdef FIX_IRIX
typedef unsigned char u_char;
typedef unsigned short u_short;
#endif

#include <netinet/tcp.h> /* TCP_NODELAY */
#include <stdio.h> /* printf */

int main()
{
	printf("TCP_NODELAY = %d\n", TCP_NODELAY);
	return 0;
}
```

To build it, I add the -isystem flag so it picks my hacky headers to mimic your system, but you won't need any of that.

Without the fix, I get the same 7 errors as you get:

```
% gcc -isystem . nodelay.c -o nodelay
In file included from nodelay.c:6:
./netinet/tcp.h:38:9: error: unknown type name ‘u_short’; did you mean ‘short’?
   38 |         u_short th_sport;               /* source port */
      |         ^~~~~~~
      |         short
./netinet/tcp.h:39:9: error: unknown type name ‘u_short’; did you mean ‘short’?
   39 |         u_short th_dport;               /* destination port */
      |         ^~~~~~~
      |         short
./netinet/tcp.h:52:9: error: unknown type name ‘u_char’; did you mean ‘char’?
   52 |         u_char  th_off:4,               /* data offset */
      |         ^~~~~~
      |         char
./netinet/tcp.h:55:9: error: unknown type name ‘u_char’; did you mean ‘char’?
   55 |         u_char  th_flags;
      |         ^~~~~~
      |         char
./netinet/tcp.h:62:9: error: unknown type name ‘u_short’; did you mean ‘short’?
   62 |         u_short th_win;                 /* window */
      |         ^~~~~~~
      |         short
./netinet/tcp.h:63:9: error: unknown type name ‘u_short’; did you mean ‘short’?
   63 |         u_short th_sum;                 /* checksum */
      |         ^~~~~~~
      |         short
./netinet/tcp.h:64:9: error: unknown type name ‘u_short’; did you mean ‘short’?
   64 |         u_short th_urp;                 /* urgent pointer */
      |         ^~~~~~~
      |         short
```

But adding those typedefs at the beginning it seems to work fine:

```
% gcc -DFIX_IRIX -isystem . nodelay.c -o nodelay
hop% ./nodelay
TCP_NODELAY = 1
```


> I don't know a lot of ways I can easily compromise and fix this on an our end; we are stuck in a similar situation to ArcaOS. We are applying patches and fixes to the system but we have to do so in a relatively conservative manner to avoid breaking things. There's not really a way I can just radically change stuff up.

If you are willing to modify the headers, you can add a guard for GCC only that does those definitions for that netinet/tcp.h file:

```
#ifdef __GNUC__
#warning "HACK: Adding extra definitions to fix GCC"
typedef unsigned char u_char;
typedef unsigned short u_short;
#endif 
/* rest of netinet/tcp.h file */
```

You can test with mipspro that it doesn't emit the warning, but only gcc does. Maybe a more universal solution is to find out why they are not being picked by GCC and maybe add the `__GNUC__` as part of the guards so the definitions are also included for gcc. If you send me a tarball with all system headers I can suggest some changes to try to fix them (mail them to me if you don't want to upload them here).

Regardless of that, I would like to make Dillo work on IRIX without modifying the system headers.

--%--
From: Sunny-Maxis
Date: Thu, 06 Mar 2025 01:16:52 +0000

Your fix did work with the caveat that stdint.h must be placed before tcp.h

Your unsetenv() fix worked as well.

I can definitely poke around and copy a set of headers in the future. This machine is not representative of most SGI machines as we have been using it for experimental purposes so I can't guarantee that the headers are accurate, so let me pull them from one of his other machines either this weekend or sometime soon in general. 

I did not think to bring this up beforehand but we did have  another issue:

For dpid (e.g. not the browser, but the plugin stuff) we have an error in GCC that says:


```main.c:232:19: error: storage size of 'select_timeout' isn't known
    struct timeval select_timeout;
                   ^~~~~~~~~~~~~~
main.c:312:14: warning: implicit declaration of function 'select' [-Wimplicit-function-declaration]
          n = select(FD_SETSIZE, &selected_set, NULL, NULL, &select_timeout);
              ^~~~~~
main.c:232:19: warning: unused variable 'select_timeout' [-Wunused-variable]
    struct timeval select_timeout;
 
```

This is not an error that I am familiar with myself as I am less than familiar with the style of programming that is being used here. If you have any insight on where I can guide the fix of this issue. 

--%--
From: rodarima
Date: Thu, 06 Mar 2025 18:23:18 +0000

> Your fix did work with the caveat that stdint.h must be placed before tcp.h
> 
> Your unsetenv() fix worked as well.

Great!

> I did not think to bring this up beforehand but we did have another issue:
> 
> For dpid (e.g. not the browser, but the plugin stuff) we have an error in GCC that says:
> 
> ```
>     struct timeval select_timeout;
>                    ^~~~~~~~~~~~~~
> main.c:312:14: warning: implicit declaration of function 'select' [-Wimplicit-function-declaration]
>           n = select(FD_SETSIZE, &selected_set, NULL, NULL, &select_timeout);
>               ^~~~~~
> main.c:232:19: warning: unused variable 'select_timeout' [-Wunused-variable]
>     struct timeval select_timeout;
>  
> ```
> 
> This is not an error that I am familiar with myself as I am less than familiar with the style of programming that is being used here. If you have any insight on where I can guide the fix of this issue.

This seems to be a similar case, we are not including the `struct timeval` or `select` definition. It looks like in IRIX we need extra headers:

https://nixdoc.net/man-pages/IRIX/man2/standard/select.2.html

So I added them to the PR. It should build fine now if that is the problem.

--%--
From: Sunny-Maxis
Date: Thu, 06 Mar 2025 22:06:24 +0000

I had to explicitly declare the struct in dpid/main.c and dpi/file.c

I think the best way to handle this would be to make a header sgi_timeval.h or something and explicitly declare the struct there. 

I can also give you the exact sys/time.h and let you give it a shot on coming up with a creative solution but on my end it's not reading the timeval struct. 

Let me know how you want to handle this. That is however the last particular error that I'm dealing with on the current release tarball. 

If in the future you want to do away with variadic macros I can probably work with you to get running on mipspro C++ in the current form although I will leave that decision up to you and your team. That is a somewhat monumental task to strip those out and that might reduce functionality in some cases or require a big rewrite so I would rather not put more work on you guys when you've been so accommodating. 

--%--
From: rodarima
Date: Wed, 19 Mar 2025 23:09:11 +0000

> I had to explicitly declare the struct in dpid/main.c and dpi/file.c
> 
> I think the best way to handle this would be to make a header sgi_timeval.h or something and explicitly declare the struct there.

We can make an explicit definition if you know the types that timeval is using in SGI. Which definition are you using? On my system they are longs:

```c
typedef long int time_t;
typedef long int suseconds_t;

struct timeval {
    time_t tv_sec;
    suseconds_t tv_usec;
};
```

> I can also give you the exact sys/time.h and let you give it a shot on coming up with a creative solution but on my end it's not reading the timeval struct.

Can you make a tarball of all headers in /usr/include (or the relevant places) and send it? If you want to keep it private, my email is my username at gmail.com. This would allow me to decide what is the best solution to support SGI in the long run.

> Let me know how you want to handle this. That is however the last particular error that I'm dealing with on the current release tarball.
> 
> If in the future you want to do away with variadic macros I can probably work with you to get running on mipspro C++ in the current form although I will leave that decision up to you and your team. That is a somewhat monumental task to strip those out and that might reduce functionality in some cases or require a big rewrite so I would rather not put more work on you guys when you've been so accommodating.

For me it would be nice to support GCC as a first step. Maybe we can evaluate later if mipspro is a suitable solution, because removing the variadic macros may not be the only problem.

--%--
From: Sunny-Maxis
Date: Thu, 20 Mar 2025 01:28:30 +0000

Sending you a tarball with the stuff within an hour, as for this issue:
```c
#if defined(__sgi) && defined(__GNUC__)
struct timeval {
time_t tv_sec;
long tv_usec;
} select_timeout;

``` 
This is the code that I used to fix the issue. I defined it for GNUC because testing with your example, mipspro doesn't care. If we ever do manage to provide support, then it should be good. 

I will reply to the Variadic macro issue in that issue with an explanation and reasoning. 

--%--
From: rodarima
Date: Sun, 30 Mar 2025 20:07:20 +0000

Thanks, I got your mail. I did some experimentation last week, and I now I understand the situation a bit better. It seems that we have 3 groups of problems:

- GCC must mimic all SGI defines of MIPSpro to be able to use the headers properly. We can add some `#ifdef` logic to detect it is doing the right thing.
- There are missing definitions in the IRIX headers for u_char, u_short, u_int and u_long. Not sure if mipspro defines this on their own, but GCC doesn't. We will need to provide our own.
- IRIX doesn't implement POSIX 2001, which is the lowest standard Dillo supports (at least that I have tested). Enabling that POSIX version doesn't cause the headers to enable enough declarations for it to work. But we can try with _XOPEN_SOURCE 520, which may be enough.

I did an experiment with a simple program that tries to detect if my intuitions are correct. Here it is. It should build fine as-is with `gcc test.c -o test` if I'm right:

```c
/* This test checks if we can provide some definitions in IRIX */

/* 1. This is only to simulate what gcc should do on MIPS but I'm using x86.
 *    Ignore this block on IRIX, as the ifdef guard won't include it. */
#ifdef __x86_64__
/* These must be provided by gcc when building for mips */
# define _MIPS_SZLONG 32
# define _MIPS_SZPTR 32
# define _MIPS_SZINT 32
# define _ABIN32 1
# define __mips__
# define _MIPSEB 1
# define _MIPS_SIM _ABIN32 /* Using the new ABI for 32 bits */
# define _LANGUAGE_C
# define _LONGLONG
/* Define __sgi to simulate a SGI compiler */
# define __sgi
#endif

/* 2. Missing definitions on SGI for BSD types. They should be in sys/types.h
 *    but they are not. Only types like ushort_t are defined, but not u_short. */
#ifdef __sgi
typedef	unsigned char	u_char;
typedef	unsigned short	u_short;
typedef	unsigned int	u_int;
typedef	unsigned long	u_long;
#endif

/* 3. Define the proper XOPEN specification here otherwise many definitions
 *    won't work. */
#define _XOPEN_SOURCE 520
//#define _POSIX_C_SOURCE 200112L

/* 4. The headers as per the manual */
#include <unistd.h>
#include <sys/types.h>
#include <bstring.h>
#include <sys/time.h>
#include <netinet/tcp.h> /* TCP_NODELAY */

/* 5. Finally a dummy test */
int main(void)
{
	fd_set set;

	FD_ZERO(&set);
	FD_SET(1, &set);
	FD_CLR(2, &set);

	struct timeval tv = { .tv_sec = TCP_NODELAY, .tv_usec = 0 };

	return select(0, &set, &set, &set, &tv);
}

```

--%--
From: Sunny-Maxis
Date: Mon, 31 Mar 2025 01:07:30 +0000

Builds fine, doesn't do anything on the commandline. Not a single complaint from GCC about it. 

ABI on irix is always n32, there's no o32 MIPS. 

IRiX 6.5.0 was released in 1998. While updates were provided for C99 support, POSIX98 is the last official supported version. 

I have not personally tested it myself but we have plenty of people who have built it in the past without problems. The reason why I haven't tested my build is simply down to GCC being hard to package for. Out of the machines my boss has running 24/7, all of them are headless, so we can't do a test easily, especially since X forwarding is broken on modern X from IRIX. 

With the manual definition of the struct in place for GCC in the files mentioned, it builds fine, so my work is done with that. 