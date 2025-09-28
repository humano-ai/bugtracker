Title: Segfault when opening https://odd.codes
Author: rodarima
Created: Mon, 01 Jan 2024 01:36:24 +0000
State: closed

Using OpenSSL 3.2.0.
```
$ dillo https://odd.codes
Domain: Default accept.
dillo_dns_init: Here we go! (threaded)
Disabling cookies.
Nav_open_url: new url='https://odd.codes'
Dns_server [0]: odd.codes is 198.54.114.150
Connecting to 198.54.114.150:443
odd.codes: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /CN=*.web-hosting.com
sha384 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Sectigo Limited/CN=Sectigo RSA Domain Validation Secure Server CA
sha384 4096-bit RSA: /C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority
** WARNING **: In 2015, browsers have begun to deprecate SHA1 certificates.
sha1 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
root: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
odd.codes: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /CN=*.web-hosting.com
sha384 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Sectigo Limited/CN=Sectigo RSA Domain Validation Secure Server CA
sha384 4096-bit RSA: /C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority
** WARNING **: In 2015, browsers have begun to deprecate SHA1 certificates.
sha1 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
root: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
odd.codes: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /CN=*.web-hosting.com
sha384 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Sectigo Limited/CN=Sectigo RSA Domain Validation Secure Server CA
sha384 4096-bit RSA: /C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority
** WARNING **: In 2015, browsers have begun to deprecate SHA1 certificates.
sha1 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
root: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
odd.codes: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /CN=*.web-hosting.com
sha384 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Sectigo Limited/CN=Sectigo RSA Domain Validation Secure Server CA
sha384 4096-bit RSA: /C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority
** WARNING **: In 2015, browsers have begun to deprecate SHA1 certificates.
sha1 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
root: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
odd.codes: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /CN=*.web-hosting.com
sha384 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Sectigo Limited/CN=Sectigo RSA Domain Validation Secure Server CA
sha384 4096-bit RSA: /C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority
** WARNING **: In 2015, browsers have begun to deprecate SHA1 certificates.
sha1 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
root: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
odd.codes: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /CN=*.web-hosting.com
...
odd.codes: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
sha256 2048-bit RSA: /CN=*.web-hosting.com
sha384 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Sectigo Limited/CN=Sectigo RSA Domain Validation Secure Server CA
sha384 4096-bit RSA: /C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority
** WARNING **: In 2015, browsers have begun to deprecate SHA1 certificates.
sha1 2048-bit RSA: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
root: /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services
odd.codes: TLSv1.3, cipher TLS_AES_256_GCM_SHA384
[1]    806346 segmentation fault (core dumped)  dillo https://odd.codes
```

--%--
From: rodarima
Date: Mon, 01 Jan 2024 01:37:30 +0000

With mbedTLS works fine.

--%--
From: rodarima
Date: Mon, 01 Jan 2024 01:41:02 +0000

Address sanitizer reports that is a stack overflow:
```
AddressSanitizer:DEADLYSIGNAL
=================================================================
==806820==ERROR: AddressSanitizer: stack-overflow on address 0x7ffe7b20cb90 (pc 0x7fa4fa6e12cd bp 0x7ffe7b20d3d0 sp 0x7ffe7b20cb90 T0)
    #0 0x7fa4fa6e12cd in __sanitizer::StackTrace::StackTrace(unsigned long const*, unsigned int) /usr/src/debug/gcc/gcc/libsanitizer/sanitizer_common/sanitizer_stacktrace.h:53
    #1 0x7fa4fa6e12cd in __sanitizer::BufferedStackTrace::BufferedStackTrace() /usr/src/debug/gcc/gcc/libsanitizer/sanitizer_common/sanitizer_stacktrace.h:113
    #2 0x7fa4fa6e12cd in __interceptor_malloc /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_malloc_linux.cpp:69
    #3 0x7fa4f9bd2241 in CRYPTO_malloc (/usr/lib/libcrypto.so.3+0x1d2241) (BuildId: 5a9162ecea246a6e3aca345c09b7fb5a4236f1d6)
    #4 0x7fa4f9bd23fd in CRYPTO_zalloc (/usr/lib/libcrypto.so.3+0x1d23fd) (BuildId: 5a9162ecea246a6e3aca345c09b7fb5a4236f1d6)
    #5 0x7fa4f9ae13fd in BIO_new_ex (/usr/lib/libcrypto.so.3+0xe13fd) (BuildId: 5a9162ecea246a6e3aca345c09b7fb5a4236f1d6)
    #6 0x5652ec83ece6 in Tls_check_cert_strength IO/../../../src/IO/tls_openssl.c:459
    #7 0x5652ec83ece6 in Tls_examine_certificate IO/../../../src/IO/tls_openssl.c:828
    #8 0x5652ec83ece6 in Tls_connect IO/../../../src/IO/tls_openssl.c:1138
    #9 0x7fa4fa577c2c in fl_wait(double) (/usr/lib/libfltk.so.1.3+0xa8c2c) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #10 0x7fa4fa51a06f in Fl::wait(double) (/usr/lib/libfltk.so.1.3+0x4b06f) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #11 0x7fa4fa51a161 in Fl::wait() (/usr/lib/libfltk.so.1.3+0x4b161) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #12 0x5652ec7b0d25 in a_Dialog_choice ../../src/dialog.cc:389
    #13 0x5652ec83e19d in Tls_check_cert_hostname IO/../../../src/IO/tls_openssl.c:666
    #14 0x5652ec83ef12 in Tls_examine_certificate IO/../../../src/IO/tls_openssl.c:829
    #15 0x5652ec83ef12 in Tls_connect IO/../../../src/IO/tls_openssl.c:1138
    #16 0x7fa4fa577c2c in fl_wait(double) (/usr/lib/libfltk.so.1.3+0xa8c2c) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #17 0x7fa4fa51a06f in Fl::wait(double) (/usr/lib/libfltk.so.1.3+0x4b06f) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #18 0x7fa4fa51a161 in Fl::wait() (/usr/lib/libfltk.so.1.3+0x4b161) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #19 0x5652ec7b0d25 in a_Dialog_choice ../../src/dialog.cc:389
    #20 0x5652ec83e19d in Tls_check_cert_hostname IO/../../../src/IO/tls_openssl.c:666
    #21 0x5652ec83ef12 in Tls_examine_certificate IO/../../../src/IO/tls_openssl.c:829
    #22 0x5652ec83ef12 in Tls_connect IO/../../../src/IO/tls_openssl.c:1138
    #23 0x7fa4fa577c2c in fl_wait(double) (/usr/lib/libfltk.so.1.3+0xa8c2c) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #24 0x7fa4fa51a06f in Fl::wait(double) (/usr/lib/libfltk.so.1.3+0x4b06f) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #25 0x7fa4fa51a161 in Fl::wait() (/usr/lib/libfltk.so.1.3+0x4b161) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #26 0x5652ec7b0d25 in a_Dialog_choice ../../src/dialog.cc:389
    #27 0x5652ec83e19d in Tls_check_cert_hostname IO/../../../src/IO/tls_openssl.c:666
    #28 0x5652ec83ef12 in Tls_examine_certificate IO/../../../src/IO/tls_openssl.c:829
    #29 0x5652ec83ef12 in Tls_connect IO/../../../src/IO/tls_openssl.c:1138
    #30 0x7fa4fa577c2c in fl_wait(double) (/usr/lib/libfltk.so.1.3+0xa8c2c) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #31 0x7fa4fa51a06f in Fl::wait(double) (/usr/lib/libfltk.so.1.3+0x4b06f) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #32 0x7fa4fa51a161 in Fl::wait() (/usr/lib/libfltk.so.1.3+0x4b161) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #33 0x5652ec7b0d25 in a_Dialog_choice ../../src/dialog.cc:389
    #34 0x5652ec83e19d in Tls_check_cert_hostname IO/../../../src/IO/tls_openssl.c:666
    #35 0x5652ec83ef12 in Tls_examine_certificate IO/../../../src/IO/tls_openssl.c:829
    #36 0x5652ec83ef12 in Tls_connect IO/../../../src/IO/tls_openssl.c:1138
    #37 0x7fa4fa577c2c in fl_wait(double) (/usr/lib/libfltk.so.1.3+0xa8c2c) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #38 0x7fa4fa51a06f in Fl::wait(double) (/usr/lib/libfltk.so.1.3+0x4b06f) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #39 0x7fa4fa51a161 in Fl::wait() (/usr/lib/libfltk.so.1.3+0x4b161) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #40 0x5652ec7b0d25 in a_Dialog_choice ../../src/dialog.cc:389
...
```