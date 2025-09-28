Title: Issues with Cocoa API on OS X 10.5 & up
Author: sevan
Created: Thu, 01 May 2025 20:59:47 +0000
State: open

Take the title with a pinch of salt as I'v only checked on OS X 10.4, 10.5, 10.11 which are all ancient.
On 10.4, there's no issue.
On 10.5, dillo launches fine and the gui is functional. However in the terminal it was launched in, it is reporting errors regarding the Cocoa API.
```
<Error>: CGContextSetTextPosition: invalid context
<Error>: CGContextSetShouldAntialias: invalid context
<Error>: CGContextSetShouldAntialias: invalid context
```
flood the terminal, an then after a short while, dillo crashes. 


```
Process:         dillo [48397]
Path:            /Users/sme/tigerbrew/bin/dillo
Identifier:      dillo
Version:         ??? (???)
Code Type:       X86 (Native)
Parent Process:  bash [135]

Interval Since Last Report:          566426 sec
Crashes Since Last Report:           83
Per-App Interval Since Last Report:  0 sec
Per-App Crashes Since Last Report:   1

Date/Time:       2025-05-01 20:57:20.168 +0100
OS Version:      Mac OS X 10.5.8 (9L31a)
Report Version:  6
Anonymous UUID:  3E54E8B4-5A3C-46D1-BBCB-860782663158

Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
Exception Codes: KERN_INVALID_ADDRESS at 0x0000000000b00028
Crashed Thread:  0

Thread 0 Crashed:
0   com.apple.CoreGraphics        	0x94f3e770 CGSConvertBGR888toRGBA8888 + 160
1   com.apple.CoreGraphics        	0x94e9758b argb32_image + 5611
2   libRIP.A.dylib                	0x939a4725 ripd_Mark + 326
3   libRIP.A.dylib                	0x9399e9a3 ripl_BltImage + 1307
4   libRIP.A.dylib                	0x93988a18 ripc_RenderImage + 273
5   libRIP.A.dylib                	0x93998e96 ripc_DrawImage + 5102
6   com.apple.CoreGraphics        	0x94e89f4d CGContextDrawImage + 397
7   libfltk.1.3.dylib             	0x0026be30 fl_scroll(int, int, int, int, int, int, void (*)(void*, int, int, int, int), void*) + 420
8   dillo                         	0x00077cc8 dw::fltk::FltkViewport::draw() + 432
9   libfltk.1.3.dylib             	0x00218264 Fl_Group::update_child(Fl_Widget&) const + 98
10  libfltk.1.3.dylib             	0x00218397 Fl_Group::draw_children() + 295
11  libfltk.1.3.dylib             	0x00218264 Fl_Group::update_child(Fl_Widget&) const + 98
12  libfltk.1.3.dylib             	0x0025809d Fl_Wizard::draw() + 169
13  libfltk.1.3.dylib             	0x00218264 Fl_Group::update_child(Fl_Widget&) const + 98
14  libfltk.1.3.dylib             	0x00218397 Fl_Group::draw_children() + 295
15  libfltk.1.3.dylib             	0x00257c94 Fl_Window::draw() + 340
16  libfltk.1.3.dylib             	0x001f96c1 -[FLView drawRect:] + 193
17  com.apple.AppKit              	0x92f1abf8 -[NSView _drawRect:clip:] + 3853
18  com.apple.AppKit              	0x92f196ef -[NSView _recursiveDisplayAllDirtyWithLockFocus:visRect:] + 1050
19  com.apple.AppKit              	0x92f18045 -[NSView _recursiveDisplayRectIfNeededIgnoringOpacity:isVisibleRect:rectIsVisibleRectForView:topView:] + 759
20  com.apple.AppKit              	0x92f144ab -[NSView _displayRectIgnoringOpacity:isVisibleRect:rectIsVisibleRectForView:] + 3090
21  com.apple.AppKit              	0x9303243c -[NSView displayIfNeededIgnoringOpacity] + 443
22  libfltk.1.3.dylib             	0x001f08e6 Fl_X::flush() + 138
23  libfltk.1.3.dylib             	0x00200e89 Fl::flush() + 91
24  libfltk.1.3.dylib             	0x001f7efa fl_mac_flush_and_wait(double) + 428
25  libfltk.1.3.dylib             	0x00200f9d Fl::wait() + 45
26  dillo                         	0x000085af main + 2799
27  dillo                         	0x00007902 start + 54

Thread 1:
0   libSystem.B.dylib             	0x9590660a select$DARWIN_EXTSN + 10
1   libSystem.B.dylib             	0x958e8055 _pthread_start + 321
2   libSystem.B.dylib             	0x958e7f12 thread_start + 34

Thread 0 crashed with X86 Thread State (32-bit):
  eax: 0x000000bf  ebx: 0x94e95fbd  ecx: 0xffffffff  edx: 0x000000be
  edi: 0x00b00020  esi: 0x000002fd  ebp: 0xbfffdec8  esp: 0xbfffdea8
   ss: 0x0000001f  efl: 0x00210202  eip: 0x94f3e770   cs: 0x00000017
   ds: 0x0000001f   es: 0x0000001f   fs: 0x00000000   gs: 0x00000037
  cr2: 0x00b00028

Binary Images:
    0x1000 -    0xa4ff7 +dillo ??? (???) <808f5c7afd57dfb6181cf3d3bc4663e2> /Users/sme/tigerbrew/bin/dillo
  0x102000 -   0x13dff0 +libjpeg.9.dylib ??? (???) <190d123ae13f22b5215a6f34775c48d9> /Users/sme/tigerbrew/lib/libjpeg.9.dylib
  0x145000 -   0x178ffb +libpng16.16.dylib ??? (???) <e711af7180f636a592be4959d5eb4f4f> /Users/sme/tigerbrew/opt/libpng/lib/libpng16.16.dylib
  0x181000 -   0x1deff7 +libwebp.7.dylib ??? (???) <2b1f4e30eea99108791a00a4845b42f4> /Users/sme/tigerbrew/lib/libwebp.7.dylib
  0x1eb000 -   0x282fec +libfltk.1.3.dylib ??? (???) <70af56a3b8eb20a2514c4419991c8496> /Users/sme/tigerbrew/lib/libfltk.1.3.dylib
  0x2ce000 -   0x2e0ffc +libz.1.dylib ??? (???) <b40bc690caf26c5ada0372856fb105aa> /Users/sme/tigerbrew/opt/zlib/lib/libz.1.dylib
  0x2e5000 -   0x3fbff3 +libiconv.2.dylib ??? (???) <8c9225a2ac30dc430cf099ff22439e65> /Users/sme/tigerbrew/opt/libiconv/lib/libiconv.2.dylib
  0x40c000 -   0x6f2bb7 +libcrypto.3.dylib ??? (???) <f7ca3fa9af8c1dfdeb57db2066655481> /Users/sme/tigerbrew/opt/openssl3/lib/libcrypto.3.dylib
  0x815000 -   0x8c3ff5 +libssl.3.dylib ??? (???) <2e72043f262140c7bd78713b54c95a59> /Users/sme/tigerbrew/opt/openssl3/lib/libssl.3.dylib
  0x8f9000 -   0x8fefff +libsharpyuv.0.dylib ??? (???) <d544660507e96239779e9e66ac5d533f> /Users/sme/tigerbrew/Cellar/webp/1.5.0/lib/libsharpyuv.0.dylib
0x14b6d000 - 0x14d75fef  com.apple.RawCamera.bundle 2.1.3 (537) <ef9996f5ec0caf58dc832a4153196a1e> /System/Library/CoreServices/RawCamera.bundle/Contents/MacOS/RawCamera
0x8fe00000 - 0x8fe2db43  dyld 97.1 (???) <458eed38a009e5658a79579e7bc26603> /usr/lib/dyld
0x9025f000 - 0x90266ffe  libbsm.dylib ??? (???) <d25c63378a5029648ffd4b4669be31bf> /usr/lib/libbsm.dylib
0x90470000 - 0x9049dfeb  libvDSP.dylib ??? (???) <f39d424bd56a0e75d5c7a2280a25cd76> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libvDSP.dylib
0x9049e000 - 0x9049eff8  com.apple.ApplicationServices 34 (34) <8f910fa65f01d401ad8d04cc933cf887> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/ApplicationServices
0x9049f000 - 0x904c8fff  libcups.2.dylib ??? (???) <2b0ab6b9fa1957ee940835d0cfd42894> /usr/lib/libcups.2.dylib
0x904c9000 - 0x90546fef  libvMisc.dylib ??? (???) /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libvMisc.dylib
0x915fa000 - 0x91602fff  com.apple.DiskArbitration 2.2.1 (2.2.1) <ba64dd6ada417b5e7be736957f380bca> /System/Library/Frameworks/DiskArbitration.framework/Versions/A/DiskArbitration
0x91603000 - 0x917d4fef  com.apple.security 5.0.7 (1) <44e26a9c40630a54d5a9f70c18483411> /System/Library/Frameworks/Security.framework/Versions/A/Security
0x917d5000 - 0x918b6ff7  libxml2.2.dylib ??? (???) <f274ba384fb55203873f9c17569ef131> /usr/lib/libxml2.2.dylib
0x919a6000 - 0x91a61fe3  com.apple.CoreServices.OSServices 228.1 (228.1) <9c640e79ad97f335730d8a49f6cb2032> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/OSServices.framework/Versions/A/OSServices
0x91a76000 - 0x91f47fbe  libGLProgrammability.dylib ??? (???) <d5cb4e7997a873cd77523689e6749acd> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGLProgrammability.dylib
0x91f7b000 - 0x91fb9fff  libGLImage.dylib ??? (???) <2e570958595e0c9c3a289158223b39ee> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGLImage.dylib
0x920de000 - 0x9247bfef  com.apple.QuartzCore 1.5.8 (1.5.8) <18113e06d296230d63a63b58baf35f55> /System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore
0x9252c000 - 0x928eafea  libLAPACK.dylib ??? (???) /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libLAPACK.dylib
0x92930000 - 0x92934fff  libGIF.dylib ??? (???) <ade6d93abe118569a7a39d11f81eb9bf> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources/libGIF.dylib
0x92935000 - 0x92953fff  libresolv.9.dylib ??? (???) <0e26b308654f33fc94a0c010a50751f9> /usr/lib/libresolv.9.dylib
0x92954000 - 0x92a8dff7  libicucore.A.dylib ??? (???) <f2819243b278259b9a622ea111ea5fd6> /usr/lib/libicucore.A.dylib
0x92a8e000 - 0x92ad7fef  com.apple.Metadata 10.5.8 (398.26) <e4d268ea45379200f03cdc7c8bedae6f> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework/Versions/A/Metadata
0x92b51000 - 0x92bdeff7  com.apple.LaunchServices 292 (292) <a41286c7c1eb20ffd5cc796f791070f0> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/LaunchServices
0x92bdf000 - 0x92c0afe7  libauto.dylib ??? (???) <4f3e58cb81da07a1662c1f647ce30225> /usr/lib/libauto.dylib
0x92c99000 - 0x92d60ff2  com.apple.vImage 3.0 (3.0) /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vImage.framework/Versions/A/vImage
0x92d61000 - 0x92debff7  com.apple.DesktopServices 1.4.9 (1.4.9) <f5e51a76d315798371b3dd35a4d46d6c> /System/Library/PrivateFrameworks/DesktopServicesPriv.framework/Versions/A/DesktopServicesPriv
0x92e12000 - 0x93610fef  com.apple.AppKit 6.5.9 (949.54) <4df5d2e2271175452103f789b4f4d8a8> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
0x93611000 - 0x9361dffe  libGL.dylib ??? (???) /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib
0x93984000 - 0x939c5fe7  libRIP.A.dylib ??? (???) <cd04df9e8993c51312c8cbcfe2539914> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreGraphics.framework/Versions/A/Resources/libRIP.A.dylib
0x939c6000 - 0x939c6ffd  com.apple.Accelerate 1.4.2 (Accelerate 1.4.2) /System/Library/Frameworks/Accelerate.framework/Versions/A/Accelerate
0x939c7000 - 0x93a21ff7  com.apple.CoreText 2.0.5 (???) <5483518a613464d043455ac661a9dcbe> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreText.framework/Versions/A/CoreText
0x93a22000 - 0x93a73ff7  com.apple.HIServices 1.7.1 (???) <ba7fd0ede540a0da08db027f87efbd60> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/HIServices.framework/Versions/A/HIServices
0x93a74000 - 0x93a84ffc  com.apple.LangAnalysis 1.6.5 (1.6.5) <d057feb38163121ffd871c564c692804> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/LangAnalysis.framework/Versions/A/LangAnalysis
0x93a85000 - 0x93a8cff7  libCGATS.A.dylib ??? (???) <8875cf11c0de0579423ac6b6ce80336d> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreGraphics.framework/Versions/A/Resources/libCGATS.A.dylib
0x93b54000 - 0x93b62ffd  libz.1.dylib ??? (???) <5ddd8539ae2ebfd8e7cc1c57525385c7> /usr/lib/libz.1.dylib
0x93b63000 - 0x93bbcff7  libGLU.dylib ??? (???) <64d010e31d7596bd8f9edc6e027d1d0c> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGLU.dylib
0x93bbd000 - 0x93c6fffb  libcrypto.0.9.7.dylib ??? (???) <d02f7e5b8a68813bb7a77f5edb34ff9d> /usr/lib/libcrypto.0.9.7.dylib
0x94a29000 - 0x94d03ff3  com.apple.CoreServices.CarbonCore 786.16 (786.16) <d2af3f75c3500c518c39fd00aed7f9b9> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/CarbonCore
0x94d04000 - 0x94d33fe3  com.apple.AE 402.3 (402.3) <dba512e47f68eea1dd0ab35f596edb34> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/AE.framework/Versions/A/AE
0x94dab000 - 0x94dcffff  libxslt.1.dylib ??? (???) <c372568bd2f7169efa0faee6546eead3> /usr/lib/libxslt.1.dylib
0x94e05000 - 0x94e0cfe9  libgcc_s.1.dylib ??? (???) <f53c808e87d1184c0f9df63aef53ce0b> /usr/lib/libgcc_s.1.dylib
0x94e63000 - 0x95503fff  com.apple.CoreGraphics 1.409.8 (???) <25020feb388637ee860451c19b613c48> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreGraphics.framework/Versions/A/CoreGraphics
0x95504000 - 0x9553bfff  com.apple.SystemConfiguration 1.9.2 (1.9.2) <41d5aeffefc6d19d471f51ae0b15024f> /System/Library/Frameworks/SystemConfiguration.framework/Versions/A/SystemConfiguration
0x9553c000 - 0x9553cffb  com.apple.installserver.framework 1.0 (8) /System/Library/PrivateFrameworks/InstallServer.framework/Versions/A/InstallServer
0x9553d000 - 0x957b9fe7  com.apple.Foundation 6.5.9 (677.26) <c68b3cff7864959becfc7fd1a384f925> /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
0x958b6000 - 0x95a1dff3  libSystem.B.dylib ??? (???) <be7a9fa5c8a925578bddcbaa72e5bf6e> /usr/lib/libSystem.B.dylib
0x95a1e000 - 0x95aabff7  com.apple.framework.IOKit 1.5.2 (???) <7a3cc24f78f93931731203854ae0d891> /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit
0x95aac000 - 0x95ac2fff  com.apple.DictionaryServices 1.0.0 (1.0.0) <ad0aa0252e3323d182e17f50defe56fc> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/DictionaryServices.framework/Versions/A/DictionaryServices
0x95b13000 - 0x95b1dfeb  com.apple.audio.SoundManager 3.9.2 (3.9.2) <0f2ba6e891d3761212cf5a5e6134d683> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/CarbonSound.framework/Versions/A/CarbonSound
0x95b1e000 - 0x95b29fe7  libCSync.A.dylib ??? (???) <f3228c803584320fde5e1bb9f04b4d44> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreGraphics.framework/Versions/A/Resources/libCSync.A.dylib
0x95b48000 - 0x95b63ff3  libPng.dylib ??? (???) <e0c3bdc3144e1ed91f1e4d00d147ff3a> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources/libPng.dylib
0x95b64000 - 0x95bdeff8  com.apple.print.framework.PrintCore 5.5.4 (245.6) <9ae833544b8249984c07544dbe6a97fa> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework/Versions/A/PrintCore
0x95cdf000 - 0x95dbffff  libobjc.A.dylib ??? (???) <3ca288b625a47bbcfe378158e4dc328f> /usr/lib/libobjc.A.dylib
0x95dc0000 - 0x95dc9fff  com.apple.speech.recognition.framework 3.7.24 (3.7.24) <17537dd39882e07142db9e5c2db170b8> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/SpeechRecognition.framework/Versions/A/SpeechRecognition
0x95dca000 - 0x95e71feb  com.apple.QD 3.11.57 (???) <35f058678972d42b88ebdf652df79956> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/QD.framework/Versions/A/QD
0x95e73000 - 0x95f24fff  edu.mit.Kerberos 6.0.15 (6.0.15) <28005ea82ba82307f185c255c25bfdd3> /System/Library/Frameworks/Kerberos.framework/Versions/A/Kerberos
0x95f25000 - 0x95f29fff  libmathCommon.A.dylib ??? (???) /usr/lib/system/libmathCommon.A.dylib
0x95f2a000 - 0x95f2affd  com.apple.Accelerate.vecLib 3.4.2 (vecLib 3.4.2) /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/vecLib
0x95f66000 - 0x96376fef  libBLAS.dylib ??? (???) /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
0x96389000 - 0x96408ff5  com.apple.SearchKit 1.2.2 (1.2.2) <3b5f3ab6a363a4d8a2bbbf74213ab0e5> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/SearchKit.framework/Versions/A/SearchKit
0x96409000 - 0x96419fff  com.apple.speech.synthesis.framework 3.7.1 (3.7.1) <9a71429c74ed6ca43eb35e1f78471b2e> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/SpeechSynthesis.framework/Versions/A/SpeechSynthesis
0x9641a000 - 0x964e5fef  com.apple.ColorSync 4.5.4 (4.5.4) /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ColorSync.framework/Versions/A/ColorSync
0x964e6000 - 0x96520fe7  com.apple.coreui 1.2 (62) /System/Library/PrivateFrameworks/CoreUI.framework/Versions/A/CoreUI
0x96537000 - 0x96556ffa  libJPEG.dylib ??? (???) <6d61215d5adfd74f75fed2e4db29a21c> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources/libJPEG.dylib
0x96557000 - 0x96564fe7  com.apple.opengl 1.5.10 (1.5.10) <e7d1198d869f45f09251f9697cbdd192> /System/Library/Frameworks/OpenGL.framework/Versions/A/OpenGL
0x96565000 - 0x965c2ffb  libstdc++.6.dylib ??? (???) <04b812dcec670daa8b7d2852ab14be60> /usr/lib/libstdc++.6.dylib
0x965c3000 - 0x965c3ffa  com.apple.CoreServices 32 (32) <2fcc8f3bd5bbfc000b476cad8e6a3dd2> /System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices
0x965ca000 - 0x965caffc  com.apple.audio.units.AudioUnit 1.5 (1.5) /System/Library/Frameworks/AudioUnit.framework/Versions/A/AudioUnit
0x96901000 - 0x96a4aff7  com.apple.ImageIO.framework 2.0.9 (2.0.9) <717938c4837f88bbe8ec613d4d25bc52> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/ImageIO
0x96a4b000 - 0x96a4dff5  libRadiance.dylib ??? (???) <73169d8c3fc31df4005e8eaa0d16bde5> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources/libRadiance.dylib
0x96b43000 - 0x96c95ff3  com.apple.audio.toolbox.AudioToolbox 1.5.3 (1.5.3) /System/Library/Frameworks/AudioToolbox.framework/Versions/A/AudioToolbox
0x96c96000 - 0x96cd5fef  libTIFF.dylib ??? (???) <2afd7f6079224311d67ab427e10bf61c> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources/libTIFF.dylib
0x96d74000 - 0x96e07ff3  com.apple.ApplicationServices.ATS 3.8 (???) <e61b0945da6ab368348a927f7428ad67> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/ATS
0x96e08000 - 0x96e8fff7  libsqlite3.0.dylib ??? (???) <aaaf72c093e13f34b96e2688b95bdb4a> /usr/lib/libsqlite3.0.dylib
0x9700a000 - 0x97312fe7  com.apple.HIToolbox 1.5.6 (???) <eece3cb8aa0a4e6843fcc1500aca61c5> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/HIToolbox
0x97367000 - 0x97367ff8  com.apple.Cocoa 6.5 (???) <e064f94d969ce25cb7de3cfb980c3249> /System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa
0x97368000 - 0x9749bfe7  com.apple.CoreFoundation 6.5.7 (476.19) <a332c8f45529ee26d2e9c36d0c723bad> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
0x9752b000 - 0x975d2fec  com.apple.CFNetwork 438.16 (438.16) <0a2f633dc532b176109547367f209ced> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CFNetwork.framework/Versions/A/CFNetwork
0x975d3000 - 0x975dfff9  com.apple.helpdata 1.0.1 (14.2) /System/Library/PrivateFrameworks/HelpData.framework/Versions/A/HelpData
0x97605000 - 0x97682feb  com.apple.audio.CoreAudio 3.1.2 (3.1.2) <782a08c44be4698597f4bbd79cac21c6> /System/Library/Frameworks/CoreAudio.framework/Versions/A/CoreAudio
0x97683000 - 0x97699fe7  com.apple.CoreVideo 1.5.1 (1.5.1) <500f88e655f9566e02e08138f38e898d> /System/Library/Frameworks/CoreVideo.framework/Versions/A/CoreVideo
0x976a4000 - 0x976a5ffc  libffi.dylib ??? (???) <a3b573eb950ca583290f7b2b4c486d09> /usr/lib/libffi.dylib
0x97963000 - 0x9798bff7  com.apple.shortcut 1.0.1 (1.0) <37e4b08cfaf9edb08b8682a06c4ec844> /System/Library/PrivateFrameworks/Shortcut.framework/Versions/A/Shortcut
0x9798c000 - 0x97a74ff3  com.apple.CoreData 100.2 (186.2) <44df326fea0236718f5ed64084e82270> /System/Library/Frameworks/CoreData.framework/Versions/A/CoreData
0x97aa7000 - 0x97aa7ffd  com.apple.vecLib 3.4.2 (vecLib 3.4.2) /System/Library/Frameworks/vecLib.framework/Versions/A/vecLib
0xfffe8000 - 0xfffebfff  libobjc.A.dylib ??? (???) /usr/lib/libobjc.A.dylib
```

On 10.11, the errors are still reported but dillo never crashes or at least it doesn't crash as quickly as it did on 10.5.
Running dillo with `CG_CONTEXT_SHOW_BACKTRACE` set shows
```
May  1 21:32:53  dillo[48118] <Error>: CGContextSetTextPosition: invalid context 0x0. Backtrace:
	  <_Z15fl_text_extentsPKcRiS1_S1_S1_+80>
	   <_ZN2dw4fltk8FltkFontC2EPNS_4core5style9FontAttrsE+236>
	    <_ZN2dw4fltk8FltkFont6createEPNS_4core5style9FontAttrsE+61>
	     <_ZN11StyleEngineC2EPN2dw4core6LayoutEPK8DilloUrlS6_f+540>
	      <a_Web_dispatch_by_type+266>
	       <Cache_process_queue+803>
	        <Cache_delayed_process_queue_callback+69>
	         <_ZL8do_timerP16__CFRunLoopTimerPv+53>
	          <__CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__+20>
	           <__CFRunLoopDoTimer+1075>
	            <__CFRunLoopDoTimers+298>
	             <__CFRunLoopRun+1841>
	              <CFRunLoopRunSpecific+296>
	               <RunCurrentEventLoopInMode+235>
	                <ReceiveNextEventCommon+184>
	                 <_BlockUntilNextEventMatchingListInModeWithFilter+71>
	                  <_DPSNextEvent+1067>
	                   <-[NSApplication _nextEventMatchingEventMask:untilDate:inMode:dequeue:]+454>
	                    <_Z21fl_mac_flush_and_waitd+549>
	                     <_ZN2Fl4waitEv+29>
	                      <main+2221>
```

Issue is on the fltk side?

--%--
From: rodarima
Date: Thu, 01 May 2025 21:25:20 +0000

Can you provide the output of `dillo -v`? Sound like a FLTK issue, but as we only support 1.3.X for now, tou can consider it to be our fault. You may be lucky to be able to upgrade to a newer 1.3.X version which fixes it. I don't think they support the 1.3 series anymore.

--%--
From: sevan
Date: Thu, 01 May 2025 21:30:04 +0000

Ancient OS X with up to date components
```
Dillo v3.2.0
Libraries: fltk/1.3.11 zlib/1.3.1 jpeg/90 png/1.6.45 webp/1.5.0 OpenSSL/3.5.0
Features: +GIF +JPEG +PNG +SVG +WEBP -XEMBED +TLS
```

--%--
From: rodarima
Date: Thu, 01 May 2025 21:48:12 +0000

Yeah, I don't think there is much you can do with FLTK 1.3 until we fix Dillo for FLTk 1.4, which is queued for the next Dillo release. You could try the FLTK 1.4.2 demos and check they work okay and that problem doesn't happen (specially the `bin/test/pack` program), otherwise you should be able to report those problem upstream in FLTK.

See: #246 

--%--
From: sevan
Date: Thu, 01 May 2025 21:53:03 +0000

Ok, I'll do that.