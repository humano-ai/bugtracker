Title: MacOS linker error, might need more info in the README
Author: ghovax
Created: Wed, 03 Jan 2024 09:18:12 +0000
State: open

When compiling with libs installed via Homebrew, I get this error that I couldn't fix (even with the way suggested on HackerNews):
```
ld: Undefined symbols:
  _iconv, referenced from:
      _Decode_charset in decode.o
      DilloHtmlForm::encodeText(__tag_iconv_t*, Dstr**) in form.o
  _iconv_close, referenced from:
      _Decode_charset_free in decode.o
      DilloHtmlForm::buildQueryData(DilloHtmlInput*) in form.o
  _iconv_open, referenced from:
      _a_Decode_charset_init in decode.o
      DilloHtmlForm::buildQueryData(DilloHtmlInput*) in form.o
      DilloHtmlForm::buildQueryData(DilloHtmlInput*) in form.o
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

How would you suggest fixing it? Adding `LDFLAGS` `-L/opt/homebrew/opt/libiconv/lib` didn't work.

--%--
From: rodarima
Date: Wed, 03 Jan 2024 11:48:09 +0000

Could you paste the output of the "./configure" or upload the config.log file? The procedure to locate the iconv library seems to be failing in your system or we are mixing libiconv / libc iconv for some targets.

As a workaround you could try adding `CPPFLAGS=-DLIBICONV_PLUG` to the configure arguments so libiconv uses the same API as the one in the libc.

--%--
From: ghovax
Date: Wed, 03 Jan 2024 12:56:32 +0000

I tried as you suggested, nothing changed. Here's the `config.log`: [https://pastebin.com/mEFG5fMc](https://pastebin.com/mEFG5fMc).

--%--
From: rodarima
Date: Mon, 08 Jan 2024 21:26:53 +0000

Thanks, I'll keep the log here too in case it expires: [log.txt](https://github.com/dillo-browser/dillo/files/13865881/log.txt)

From the log, libiconv seems to be available in your system:

> PATH: /opt/homebrew/opt/libiconv/bin/

And it is found by the configure:

```
configure:7396: checking for iconv.h
configure:7396: gcc -c -g -O2 -I/opt/homebrew/Cellar/openssl@3/3.2.0_1/include conftest.c >&5
configure:7396: $? = 0
configure:7396: result: yes
configure:7406: checking for iconv_open in -liconv
configure:7435: gcc -o conftest -g -O2 -I/opt/homebrew/Cellar/openssl@3/3.2.0_1/include -L/opt/homebrew/Cellar/openssl@3/3.2.0_1/lib conftest.c -liconv   >&5
configure:7435: $? = 0
configure:7447: result: yes
```

I'm thinking your issue may be related to this: https://stackoverflow.com/questions/57734434/libiconv-or-iconv-undefined-symbol-on-mac-osx

We don't provide yet a `--with-iconv` option but it should be equivalent of using:
```
./configure 'LDFLAGS=-L/opt/homebrew/opt/libiconv/lib' 'CPPFLAGS=-I/opt/homebrew/opt/libiconv/include'
```

--%--
From: orbit-stabilizer
Date: Fri, 19 Jan 2024 20:11:01 +0000

I have the same issue. Installed via Homebrew on an Intel based Mac.

--%--
From: rodarima
Date: Thu, 01 Feb 2024 18:28:23 +0000

This issue is likely happening because there are several iconv libraries installed in your system, which are incompatible among themselves and they are in the same library directory also used for other dependencies of Dillo. A way to discover multiple iconv installations is by running `which -a iconv` or better (but slower) `find / -name "libiconv.so*"`.

When the autoconf script finds one iconv library that is working, assumes that it will work for the next discovery steps. This assumption is not correct as adding the search path for other libraries may switch the selection of the iconv library, and should be corrected so that once a iconv library is found, the full path is used to link to that one specifically. Otherwise, other -L flags used for other libraries will cause the linker to choose another iconv library that is not compatible with objects already built.

We could spend some effort trying to fix the iconv search procedure, but I believe it would be better invested if we instead switch to another build system like cmake which [already has the logic to search and pin the full iconv library path](https://cmake.org/cmake/help/latest/module/FindIconv.html) (and also would solve some other problems).

However, I don't want to introduce those big changes for the 3.1 release, so the proper solution would have to wait a bit. For now, fiddling with the CFLAGS and LDFLAGS or removing the other iconv libraries should be a viable workaround.