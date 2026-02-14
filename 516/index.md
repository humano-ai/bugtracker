Title: Segfault while running SSL Labs CurveBall test
Author: Rodrigo Arias Mallo
Created: Thu, 15 Jan 2026 22:09:14 +0100
State: closed

Reported-by: Alex

See: <https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/thread/ULVOL6LZP7O7C5MAXXU4XYLOLQDKQPKS/>

Segfault when loading https://www.ssllabs.com:10446/. Reproduced with LibreSSL
4.2.1 but not with OpenSSL on Linux:

    % LD_LIBRARY_PATH=/usr/lib/libressl/ src/dillo https://www.ssllabs.com:10446/
    Keys::parseKey: Invalid command name: 'rel-next'
    Keys::parseKey: Invalid command name: 'rel-prev'
    Keys::parseKey: Invalid command name: 'rel-up'
    dillo_dns_init: Here we go! (threaded)
    TLS library: LibreSSL 4.2.1
    Enabling cookies as from cookiesrc...
    Nav_open_url: new url='https://www.ssllabs.com:10446/'
    Dns_server [0]: www.ssllabs.com is 69.67.183.100
    Connecting to 69.67.183.100:10446
    www.ssllabs.com:10446: TLSv1.2, cipher ECDHE-ECDSA-AES256-GCM-SHA384
    ecdsa-with-SHA256 384-bit EC: /C=US/ST=California/L=Foster City/O=Qualys, Inc./OU=SSLLabs CurveBall Leaf/CN=www.ssllabs.com
    ecdsa-with-SHA256 AddressSanitizer:DEADLYSIGNAL
    =================================================================
    ==1123582==ERROR: AddressSanitizer: SEGV on unknown address 0x000000000000 (pc 0x7f31c4d0b3a4 bp 0x7ffc3dc12070 sp 0x7ffc3dc10eb8 T0)
    ==1123582==The signal is caused by a READ memory access.
    ==1123582==Hint: address points to the zero page.
        #0 0x7f31c4d0b3a4 in EVP_PKEY_id (/usr/lib/libressl/libcrypto.so.57+0xae3a4) (BuildId: 15f17022dc7dbd5298bf906f2ef4e53d12c52015)
        #1 0x55c7110c71cf in Tls_check_cert_strength ../../../src/IO/tls_openssl.c:525
        #2 0x55c7110c87d1 in Tls_examine_certificate ../../../src/IO/tls_openssl.c:864
        #3 0x55c7110ca507 in Tls_connect ../../../src/IO/tls_openssl.c:1207
        #4 0x55c7110ca6e0 in Tls_connect_cb ../../../src/IO/tls_openssl.c:1239
        #5 0x7f31c4ab06ec in fl_wait(double) (/usr/lib/libfltk.so.1.3+0xa66ec) (BuildId: 35d154011fe6e73efbad51f873a8c4e488e91451)
        #6 0x7f31c4a4e0fd in Fl::wait(double) (/usr/lib/libfltk.so.1.3+0x440fd) (BuildId: 35d154011fe6e73efbad51f873a8c4e488e91451)
        #7 0x7f31c4a4e232 in Fl::wait() (/usr/lib/libfltk.so.1.3+0x44232) (BuildId: 35d154011fe6e73efbad51f873a8c4e488e91451)
        #8 0x55c710fd9009 in main ../../src/dillo.cc:621
        #9 0x7f31c4227634  (/usr/lib/libc.so.6+0x27634) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
        #10 0x7f31c42276e8 in __libc_start_main (/usr/lib/libc.so.6+0x276e8) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
        #11 0x55c710fd5f74 in _start (/home/ram/dev/dillo/git/build-asan/src/dillo+0x12f74) (BuildId: 850e3f88a121a05841fca5389243b0482d69b6b0)

    ==1123582==Register values:
    rax = 0x0000000000000000  rbx = 0x00007b31c1d75080  rcx = 0x00007f31c3d19048  rdx = 0x0000000000000000
    rdi = 0x0000000000000000  rsi = 0x0000000000000000  rbp = 0x00007ffc3dc12070  rsp = 0x00007ffc3dc10eb8
     r8 = 0x0000000000000000   r9 = 0x00007ffc3dc10e30  r10 = 0x00007f31c3d190c0  r11 = 0x00007f31c3d19060
    r12 = 0x00007b31c1d750e0  r13 = 0x00000f66383aea10  r14 = 0x0000000000001000  r15 = 0x00007ffc3dc10ec0
    AddressSanitizer can not provide additional info.
    SUMMARY: AddressSanitizer: SEGV (/usr/lib/libressl/libcrypto.so.57+0xae3a4) (BuildId: 15f17022dc7dbd5298bf906f2ef4e53d12c52015) in EVP_PKEY_id
    ==1123582==ABORTING

--%--
From: Rodrigo Arias Mallo
Date: Sat, 14 Feb 2026 21:04:24 +0100

Fixed in
<https://git.dillo-browser.org/dillo/commit/?id=d51d6bf2b0b2971445b0501652dfd8e8e8ef00cf>
