Title: *** [dillo/3.1.1] Not implemented: OOFFloatsMgr::tellIncompletePosition1 ***
Author: rodarima
Created: Sun, 09 Jun 2024 14:11:33 +0000
State: open

Managed to make Dillo abort:
```
% gdb --args src/dillo www.citibank.com
...
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.3.0 9 Apr 2024
Enabling cookies as from cookiesrc...
Nav_open_url: new url='http://www.citibank.com'
[New Thread 0x7ffff60006c0 (LWP 2852263)]
Dns_server [0]: www.citibank.com is 95.100.123.225
Connecting to 95.100.123.225:80
[Thread 0x7ffff60006c0 (LWP 2852263) exited]
Nav_open_url: new url='https://www.citi.com/'
[New Thread 0x7ffff60006c0 (LWP 2852264)]
Dns_server [0]: www.citi.com is 95.100.123.225
Connecting to 95.100.123.225:443
[Thread 0x7ffff60006c0 (LWP 2852264) exited]
www.citi.com: TLSv1.2, cipher ECDHE-RSA-AES256-GCM-SHA384
sha256 2048-bit RSA: /jurisdictionC=US/jurisdictionST=Delaware/businessCategory=Private Organization/serialNumber=2154254/C=US/ST=New York/L=New York/O=Citigroup Inc./CN=www.citi.com
sha256 2048-bit RSA: /C=US/O=DigiCert Inc/CN=DigiCert EV RSA CA G2
root: /C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert Global Root G2
no values for shorthand property 'padding'
no values for shorthand property 'padding'
NumPendingStyleSheets=1
*** [dillo/3.1.1] Not implemented: OOFFloatsMgr::tellIncompletePosition1 ***

Thread 1 "dillo" received signal SIGABRT, Aborted.
0x00007ffff6eac194 in ?? () from /usr/lib/libc.so.6
(gdb) bt
#0  0x00007ffff6eac194 in ?? () from /usr/lib/libc.so.6
#1  0x00007ffff6e58d70 in raise () from /usr/lib/libc.so.6
#2  0x00007ffff6e404c0 in abort () from /usr/lib/libc.so.6
#3  0x0000555555616ce1 in lout::misc::notImplemented (name=0x55555566d4b0 "OOFFloatsMgr::tellIncompletePosition1") at ../../dw/../lout/misc.hh:58
#4  0x0000555555618eb2 in dw::oof::OOFFloatsMgr::tellIncompletePosition1 (this=0x555555907cf0, generator=0x555555a3cc60, widget=0x555555a3ad90, x=0, y=0) at ../../dw/ooffloatsmgr.cc:861
#5  0x000055555562f823 in dw::Textblock::wrapWordInFlow (this=0x555555a3ad90, wordIndex=1, wrapAll=true) at ../../dw/textblock_linebreaking.cc:774
#6  0x000055555562f149 in dw::Textblock::wordWrap (this=0x555555a3ad90, wordIndex=1, wrapAll=true) at ../../dw/textblock_linebreaking.cc:578
#7  0x0000555555632d8c in dw::Textblock::showMissingLines (this=0x555555a3ad90) at ../../dw/textblock_linebreaking.cc:2187
#8  0x000055555562345c in dw::Textblock::sizeRequestImpl (this=0x555555a3ad90, requisition=0x555555ab7e50, numPos=0, references=0x555555af0540, x=0x555555af0560, y=0x555555af0500)
    at ../../dw/textblock.cc:347
#9  0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x555555a3ad90, requisition=0x555555ab7e50, numPos=0, references=0x555555af0540, x=0x555555af0560, y=0x555555af0500)
    at ../../dw/widget.cc:580
#10 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x555555a38e40, wordIndex=2, widget=0x555555a3ad90, size=0x555555ab7e50) at ../../dw/textblock.cc:2338
#11 0x000055555563259c in dw::Textblock::rewrap (this=0x555555a38e40) at ../../dw/textblock_linebreaking.cc:1940
#12 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x555555a38e40, requisition=0x555555a39700, numPos=0, references=0x555555af0380, x=0x555555af0420, y=0x555555af0400)
    at ../../dw/textblock.cc:346
#13 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x555555a38e40, requisition=0x555555a39700, numPos=0, references=0x555555af0380, x=0x555555af0420, y=0x555555af0400)
    at ../../dw/widget.cc:580
#14 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x555555a34150, wordIndex=6, widget=0x555555a38e40, size=0x555555a39700) at ../../dw/textblock.cc:2338
#15 0x000055555563259c in dw::Textblock::rewrap (this=0x555555a34150) at ../../dw/textblock_linebreaking.cc:1940
#16 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x555555a34150, requisition=0x555555a347d0, numPos=0, references=0x555555af02c0, x=0x555555af02a0, y=0x555555af0280)
    at ../../dw/textblock.cc:346
#17 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x555555a34150, requisition=0x555555a347d0, numPos=0, references=0x555555af02c0, x=0x555555af02a0, y=0x555555af0280)
    at ../../dw/widget.cc:580
#18 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x555555a334c0, wordIndex=0, widget=0x555555a34150, size=0x555555a347d0) at ../../dw/textblock.cc:2338
#19 0x000055555563259c in dw::Textblock::rewrap (this=0x555555a334c0) at ../../dw/textblock_linebreaking.cc:1940
#20 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x555555a334c0, requisition=0x555555a33f90, numPos=0, references=0x555555af0120, x=0x555555af0100, y=0x555555af0200)
    at ../../dw/textblock.cc:346
#21 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x555555a334c0, requisition=0x555555a33f90, numPos=0, references=0x555555af0120, x=0x555555af0100, y=0x555555af0200)
    at ../../dw/widget.cc:580
#22 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x555555a32f90, wordIndex=0, widget=0x555555a334c0, size=0x555555a33f90) at ../../dw/textblock.cc:2338
#23 0x000055555563259c in dw::Textblock::rewrap (this=0x555555a32f90) at ../../dw/textblock_linebreaking.cc:1940
#24 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x555555a32f90, requisition=0x555555ae4500, numPos=0, references=0x555555af0140, x=0x555555af01a0, y=0x555555af0180)
    at ../../dw/textblock.cc:346
#25 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x555555a32f90, requisition=0x555555ae4500, numPos=0, references=0x555555af0140, x=0x555555af01a0, y=0x555555af0180)
    at ../../dw/widget.cc:580
#26 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x555555a2f230, wordIndex=4, widget=0x555555a32f90, size=0x555555ae4500) at ../../dw/textblock.cc:2338
#27 0x000055555563259c in dw::Textblock::rewrap (this=0x555555a2f230) at ../../dw/textblock_linebreaking.cc:1940
#28 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x555555a2f230, requisition=0x555555a2f8a0, numPos=0, references=0x555555af0080, x=0x555555af0060, y=0x555555af0040)
    at ../../dw/textblock.cc:346
#29 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x555555a2f230, requisition=0x555555a2f8a0, numPos=0, references=0x555555af0080, x=0x555555af0060, y=0x555555af0040)
    at ../../dw/widget.cc:580
#30 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x555555a2e610, wordIndex=0, widget=0x555555a2f230, size=0x555555a2f8a0) at ../../dw/textblock.cc:2338
#31 0x000055555563259c in dw::Textblock::rewrap (this=0x555555a2e610) at ../../dw/textblock_linebreaking.cc:1940
#32 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x555555a2e610, requisition=0x555555aedfc0, numPos=0, references=0x555555aeff60, x=0x555555aefca0, y=0x555555aefd40)
    at ../../dw/textblock.cc:346
#33 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x555555a2e610, requisition=0x555555aedfc0, numPos=0, references=0x555555aeff60, x=0x555555aefca0, y=0x555555aefd40)
--Type <RET> for more, q to quit, c to continue without paging--
    at ../../dw/widget.cc:580
#34 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x555555a2deb0, wordIndex=0, widget=0x555555a2e610, size=0x555555aedfc0) at ../../dw/textblock.cc:2338
#35 0x000055555563259c in dw::Textblock::rewrap (this=0x555555a2deb0) at ../../dw/textblock_linebreaking.cc:1940
#36 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x555555a2deb0, requisition=0x555555a2e4e0, numPos=0, references=0x555555aefd80, x=0x555555aefee0, y=0x555555aeff20)
    at ../../dw/textblock.cc:346
#37 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x555555a2deb0, requisition=0x555555a2e4e0, numPos=0, references=0x555555aefd80, x=0x555555aefee0, y=0x555555aeff20)
    at ../../dw/widget.cc:580
#38 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x5555559f4b40, wordIndex=0, widget=0x555555a2deb0, size=0x555555a2e4e0) at ../../dw/textblock.cc:2338
#39 0x000055555563259c in dw::Textblock::rewrap (this=0x5555559f4b40) at ../../dw/textblock_linebreaking.cc:1940
#40 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x5555559f4b40, requisition=0x555555a2dd80, numPos=0, references=0x555555aefde0, x=0x555555aeff00, y=0x555555aefd00)
    at ../../dw/textblock.cc:346
#41 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x5555559f4b40, requisition=0x555555a2dd80, numPos=0, references=0x555555aefde0, x=0x555555aeff00, y=0x555555aefd00)
    at ../../dw/widget.cc:580
#42 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x5555559f41f0, wordIndex=0, widget=0x5555559f4b40, size=0x555555a2dd80) at ../../dw/textblock.cc:2338
#43 0x000055555563259c in dw::Textblock::rewrap (this=0x5555559f41f0) at ../../dw/textblock_linebreaking.cc:1940
#44 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x5555559f41f0, requisition=0x5555559f4840, numPos=0, references=0x555555aefd60, x=0x555555aefce0, y=0x555555aefda0)
    at ../../dw/textblock.cc:346
#45 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x5555559f41f0, requisition=0x5555559f4840, numPos=0, references=0x555555aefd60, x=0x555555aefce0, y=0x555555aefda0)
    at ../../dw/widget.cc:580
#46 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x5555559f3620, wordIndex=0, widget=0x5555559f41f0, size=0x5555559f4840) at ../../dw/textblock.cc:2338
#47 0x000055555563259c in dw::Textblock::rewrap (this=0x5555559f3620) at ../../dw/textblock_linebreaking.cc:1940
#48 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x5555559f3620, requisition=0x555555aeeb00, numPos=0, references=0x555555aefe60, x=0x555555aefec0, y=0x555555aeffc0)
    at ../../dw/textblock.cc:346
#49 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x5555559f3620, requisition=0x555555aeeb00, numPos=0, references=0x555555aefe60, x=0x555555aefec0, y=0x555555aeffc0)
    at ../../dw/widget.cc:580
#50 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x55555581b610, wordIndex=8, widget=0x5555559f3620, size=0x555555aeeb00) at ../../dw/textblock.cc:2338
#51 0x000055555563259c in dw::Textblock::rewrap (this=0x55555581b610) at ../../dw/textblock_linebreaking.cc:1940
#52 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x55555581b610, requisition=0x555555aef8e0, numPos=0, references=0x555555aefbc0, x=0x555555aefbe0, y=0x555555aefc00)
    at ../../dw/textblock.cc:346
#53 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x55555581b610, requisition=0x555555aef8e0, numPos=0, references=0x555555aefbc0, x=0x555555aefbe0, y=0x555555aefc00)
    at ../../dw/widget.cc:580
#54 0x000055555562942c in dw::Textblock::calcSizeOfWidgetInFlow (this=0x55555581fb40, wordIndex=0, widget=0x55555581b610, size=0x555555aef8e0) at ../../dw/textblock.cc:2338
#55 0x000055555563259c in dw::Textblock::rewrap (this=0x55555581fb40) at ../../dw/textblock_linebreaking.cc:1940
#56 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x55555581fb40, requisition=0x55555591dcf0, numPos=0, references=0x0, x=0x0, y=0x0) at ../../dw/textblock.cc:346
#57 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x55555581fb40, requisition=0x55555591dcf0, numPos=0, references=0x0, x=0x0, y=0x0) at ../../dw/widget.cc:580
#58 0x0000555555629598 in dw::Textblock::calcSizeOfWidgetInFlow (this=0x55555583b7d0, wordIndex=0, widget=0x55555581fb40, size=0x55555591dcf0) at ../../dw/textblock.cc:2394
#59 0x000055555563259c in dw::Textblock::rewrap (this=0x55555583b7d0) at ../../dw/textblock_linebreaking.cc:1940
#60 0x0000555555623450 in dw::Textblock::sizeRequestImpl (this=0x55555583b7d0, requisition=0x7fffffffd554, numPos=0, references=0x0, x=0x0, y=0x0) at ../../dw/textblock.cc:346
#61 0x000055555564bdf6 in dw::core::Widget::sizeRequest (this=0x55555583b7d0, requisition=0x7fffffffd554, numPos=0, references=0x0, x=0x0, y=0x0) at ../../dw/widget.cc:580
#62 0x000055555563ea4e in dw::core::Layout::resizeIdle (this=0x55555592f410) at ../../dw/layout.cc:911
#63 0x00005555555e9635 in dw::fltk::FltkPlatform::generalIdle (this=0x55555591cab0) at ../dw/../../dw/fltkplatform.cc:630
#64 0x00005555555e9598 in dw::fltk::FltkPlatform::generalStaticIdle (data=0x55555591cab0) at ../dw/../../dw/fltkplatform.cc:620
#65 0x00007ffff7dae011 in Fl::wait(double) () from /usr/lib/libfltk.so.1.3
#66 0x00007ffff7dae12a in Fl::run() () from /usr/lib/libfltk.so.1.3
#67 0x00005555555a9c55 in main (argc=2, argv=0x7fffffffd7c8) at ../../src/dillo.cc:582
```