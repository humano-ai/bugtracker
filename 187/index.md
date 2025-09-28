Title: Configure should stop when no compiler is found
Author: rodarima
Created: Sat, 08 Jun 2024 13:00:13 +0000
State: closed

From https://fosstodon.org/@peterderslowake@troet.cafe/112581116611364553:
```
peter@letytjud:~/build/dillo-3.1.1/build> ../configure
checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking target system type... x86_64-pc-linux-gnu
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a race-free mkdir -p... /usr/bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether make supports nested variables... yes
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether the compiler supports GNU C... yes
checking whether gcc accepts -g... yes
checking for gcc option to enable C11 features... none needed
checking whether gcc understands -c and -o together... yes
checking whether make supports the include directive... yes (GNU style)
checking dependency style of gcc... gcc3
checking for g++... no
checking for c++... no
checking for gpp... no
checking for aCC... no
checking for CC... no
checking for cxx... no
checking for cc++... no
checking for cl.exe... no
checking for FCC... no
checking for KCC... no
checking for RCC... no
checking for xlC_r... no
checking for xlC... no
checking for clang++... no
checking whether the compiler supports GNU C++... no
checking whether g++ accepts -g... no
checking for g++ option to enable C++11 features... unsupported
checking for g++ option to enable C++98 features... unsupported
checking dependency style of g++... none
checking for ranlib... ranlib
checking how to run the C preprocessor... gcc -E
checking for stdio.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for strings.h... yes
checking for sys/stat.h... yes
checking for sys/types.h... yes
checking for unistd.h... yes
checking size of char... 1
checking size of short... 2
checking size of long... 8
checking size of int... 4
checking size of void *... 8
checking for int16_t... yes
checking for uint16_t... yes
checking for int32_t... yes
checking for uint32_t... yes
checking for gethostbyname... yes
checking for setsockopt... yes
checking for socklen_t... socklen_t
checking for fltk-config... /usr/bin/fltk-config
checking FLTK 1.3... yes
checking whether to link to X11... no
checking for jpeglib.h... yes
checking for jpeg_destroy_decompress in -ljpeg... yes
checking for zlib.h... yes
checking for zlibVersion in -lz... yes
checking for libpng-config... /usr/bin/libpng16-config
checking for libpng version... 1.6.43
checking for openssl/ssl.h... yes
checking for SSL_write in -lssl... yes
configure: Using OpenSSL as TLS library.
checking for iconv.h... yes
checking for iconv_open in -liconv... no
checking for iconv_open in -lc... yes
checking for pthread_create in -lpthread... yes
checking for fcntl.h... yes
checking for unistd.h... (cached) yes
checking for sys/uio.h... yes
checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating Makefile
config.status: creating dlib/Makefile
config.status: creating dpip/Makefile
config.status: creating dpid/Makefile
config.status: creating dpi/Makefile
config.status: creating doc/Makefile
config.status: creating dw/Makefile
config.status: creating lout/Makefile
config.status: creating src/Makefile
config.status: creating src/IO/Makefile
config.status: creating test/Makefile
config.status: creating test/unit/Makefile
config.status: creating test/dw/Makefile
config.status: creating test/html/Makefile
config.status: creating config.h
config.status: executing depfiles commands

Configuration summary:

  CXX     : g++
  CXXFLAGS:  -Wall -W -Wno-unused-parameter -fno-rtti -fno-exceptions

  TLS enabled: yes
  TLS library: OpenSSL
  TLS flags  : -lcrypto -lssl

  Cookies enabled: yes
  XEmbed enabled : yes
  RTFL enabled   : no
  JPEG enabled   : yes
  PNG enabled    : yes
  GIF enabled    : yes

  HTML tests     : no

peter@letytjud:~/build/dillo-3.1.1/build> make
make  all-recursive
make[1]: Entering directory '/home/peter/build/dillo-3.1.1/build'
Making all in lout
make[2]: Entering directory '/home/peter/build/dillo-3.1.1/build/lout'
source='../../lout/container.cc' object='container.o' libtool=no \
DEPDIR=.deps depmode=none /bin/sh ../../depcomp \
g++ -DHAVE_CONFIG_H -I. -I../../lout -I..  -I../.. -DCUR_WORKING_DIR='"/home/peter/build/dillo-3.1.1/build/lout"'   -Wall -W -Wno-unused-parameter -fno-rtti -fno-exceptions -c -o container.o ../../lout/container.cc
../../depcomp: riadok 772: exec: g++: nenÃ¡jdenÃ©
make[2]: *** [Makefile:399: container.o] Error 127
make[2]: Leaving directory '/home/peter/build/dillo-3.1.1/build/lout'
make[1]: *** [Makefile:559: all-recursive] Error 1
make[1]: Leaving directory '/home/peter/build/dillo-3.1.1/build'
make: *** [Makefile:381: all] Error 2
peter@letytjud:~/build/dillo-3.1.1/build> 
```