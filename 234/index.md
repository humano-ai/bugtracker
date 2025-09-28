Title: Blurry font rendering [Mac]
Author: philocalyst
Created: Tue, 06 Aug 2024 03:34:08 +0000
State: closed

Sometimes without interaction, but always with, the text will appear blurry when rendering in dillo (3.1.1). I'm on macos 14.6, FLTK 1.3.9. Attached is an example. any help would be appreciated!
<img width="1512" alt="71157" src="https://github.com/user-attachments/assets/9be5ec78-9876-4224-a2b0-8173cb71f600">


--%--
From: rodarima
Date: Tue, 06 Aug 2024 08:46:08 +0000

That is an interesting bug. Here is a 8x magnified picture of the issue:

<img width="776" alt="2" src="https://github.com/user-attachments/assets/81165e41-1a4f-4ec7-9685-715d4925db76">

I don't have any Apple computer to test myself. If you used homebrew, could you test if you can reproduce the same issue with the [HEAD (master) version of FLTK](https://formulae.brew.sh/formula/fltk)? You probably need to remove FLTK 1.3.9 first to be sure is not used.

--%--
From: philocalyst
Date: Tue, 06 Aug 2024 19:46:51 +0000

Getting this error preventing me from doing so: 

`configure: error: FLTK 1.3 required; version found: 1.4.0 `

I tried also switching my dillo install to HEAD but to no avail :(
Is there anything else I can do from my side to help debug? 


--%--
From: rodarima
Date: Tue, 06 Aug 2024 22:54:41 +0000

> configure: error: FLTK 1.3 required; version found: 1.4.0

This is caused by a check in the configure.ac which you can adjust to work with
1.4.0.

To test it yourself, you would need to build Dillo from source yourself, which shouldn't be hard.

You can probably get it done with these commands (assuming you already installed FLTK fomr HEAD):

```
$ git clone https://github.com/dillo-browser/dillo.git
$ cd dillo
$ sed -i 's/1\.3\.\*)/1.4.*)/' configure.ac
$ ./autogen.sh
$ mkdir build
$ cd build
$ brew install autoconf automake openssl@3
$ ../configure --prefix=/usr/local LDFLAGS="-L`brew --prefix openssl`/lib" CPPFLAGS="-I`brew --prefix openssl`/include"
$ make
$ sudo make install
```

--%--
From: amandasystems
Date: Mon, 09 Sep 2024 09:05:11 +0000

Note: the sed command assumes GNU sed, but that's available in homebrew too as `gsed`.

It looks great on my machine (macOS 14.6.1 (23G93)) with FLTK HEAD:

<img width="892" alt="image" src="https://github.com/user-attachments/assets/d5e13dd7-a9fd-4805-8c65-3bf1d6e00514">


--%--
From: rodarima
Date: Mon, 09 Sep 2024 18:58:06 +0000

> Note: the sed command assumes GNU sed, but that's available in homebrew too as gsed.

Oops :-)

> It looks great on my machine (macOS 14.6.1 (23G93)) with FLTK HEAD:

Nice!, can you also reproduce the same blurry font problem with FLTK 1.3.9? If so, it would probably be a bug in FLTK that is fixed in 1.4, which would be no work for us.

--%--
From: amandasystems
Date: Thu, 12 Sep 2024 10:08:33 +0000

The blurry text is triggered only when resizing the window _and letting go of the drag handle_ for me. While the window is resizing, the blur is absent. As soon as I release it, it's there, and stays there even if I resize again. I haven't checked if it appears if I reload the page.

It happens both with the package from Homebrew and git master.

It does not happen with latest FLTK (HEAD), so I can confirm that it's an FLTK issue at least for me.




--%--
From: rodarima
Date: Sat, 14 Sep 2024 06:53:23 +0000

> It does not happen with latest FLTK (HEAD), so I can confirm that it's an FLTK issue at least for me.

Thanks for testing. Then I'll close this and focus on supporting FLTK 1.4 properly (https://github.com/dillo-browser/dillo/issues/246).