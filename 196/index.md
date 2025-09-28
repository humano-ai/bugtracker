Title: Segfault when clicking the Done button on downloads dialog
Author: rodarima
Created: Wed, 12 Jun 2024 19:00:01 +0000
State: closed

See: https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/message/IPWQYKTYTO5G2BH3UU5224FRUFWCVGSO/

Steps to reproduce:

- Download a file.
- Wait until it completes.
- Click the "Done" button on the downloads dialog.

```
** ERROR **: [Dpi_read_comm_keys] No such file or directory
Dpi_blocking_start_dpid: try 1
[dpid]: a_Misc_mksecret: d4839d11
dpid started
[downloads dpi]: started...
[downloads dpi]: wget status 0
AddressSanitizer:DEADLYSIGNAL
=================================================================
==3393563==ERROR: AddressSanitizer: SEGV on unknown address 0x64ecf64712d0 (pc 0x7870ef628f74 bp 0x64ecf64712d0 sp 0x7ffc09ebd860 T0)
==3393563==The signal is caused by a WRITE memory access.
    #0 0x7870ef628f74 in bool __sanitizer::atomic_compare_exchange_strong<__sanitizer::atomic_uint8_t>(__sanitizer::atomic_uint8_t volatile*, __sanitizer::atomic_uint8_t::Type*, __sanitizer::atomic_uint8_t::Type, __sanitizer::memory_order) /usr/src/debug/gcc/gcc/libsanitizer/sanitizer_common/sanitizer_atomic_clang.h:81
    #1 0x7870ef628f74 in __asan::Allocator::AtomicallySetQuarantineFlagIfAllocated(__asan::AsanChunk*, void*, __sanitizer::BufferedStackTrace*) /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_allocator.cpp:610
    #2 0x7870ef628f74 in __asan::Allocator::Deallocate(void*, unsigned long, unsigned long, __sanitizer::BufferedStackTrace*, __asan::AllocType) /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_allocator.cpp:685
    #3 0x7870ef628f74 in __asan::asan_free(void*, __sanitizer::BufferedStackTrace*, __asan::AllocType) /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_allocator.cpp:944
    #4 0x7870ef6ddd71 in __interceptor_free /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_malloc_linux.cpp:53
    #5 0x64ecf646b2d3 in dFree ../../dlib/dlib.c:68
    #6 0x64ecf6461fe1 in DLItem::~DLItem() ../../dpi/downloads.cc:436
    #7 0x64ecf6465ebf in DLWin::del(int) ../../dpi/downloads.cc:970
    #8 0x64ecf646548a in update_cb ../../dpi/downloads.cc:822
    #9 0x7870ef519f9b in Fl::wait(double) (/usr/lib/libfltk.so.1.3+0x4af9b) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #10 0x7870ef51a129 in Fl::run() (/usr/lib/libfltk.so.1.3+0x4b129) (BuildId: e56a0c2bbd29f4522bca2e4c3f0bc13c2dc8803a)
    #11 0x64ecf6466b0d in main ../../dpi/downloads.cc:1122
    #12 0x7870eec41d49  (/usr/lib/libc.so.6+0x25d49) (BuildId: 915eeec6439cfded1125deefc44a8d73e57873d9)
    #13 0x7870eec41e0b in __libc_start_main (/usr/lib/libc.so.6+0x25e0b) (BuildId: 915eeec6439cfded1125deefc44a8d73e57873d9)
    #14 0x64ecf645e274 in _start (/usr/local/lib/dillo/dpi/downloads/downloads.dpi+0x8274) (BuildId: 528bdd343ccff0d5114daa60d785f9caa56bb59c)

AddressSanitizer can not provide additional info.
SUMMARY: AddressSanitizer: SEGV /usr/src/debug/gcc/gcc/libsanitizer/sanitizer_common/sanitizer_atomic_clang.h:81 in bool __sanitizer::atomic_compare_exchange_strong<__sanitizer::atomic_uint8_t>(__sanitizer::atomic_uint8_t volatile*, __sanitizer::atomic_uint8_t::Type*, __sanitizer::atomic_uint8_t::Type, __sanitizer::memory_order)
==3393563==ABORTING
```