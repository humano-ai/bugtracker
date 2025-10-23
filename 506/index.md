Title: Segmentation fault in Amazon login form
Author: Rodrigo Arias Mallo
Created: Mon, 20 Oct 2025 20:53:56 +0200
State: open

There is no resource for an input in the form:

    Thread 1 "dillo" received signal SIGSEGV, Segmentation fault.
    0x00005555555a4fd6 in dw::core::ui::Embed::getResource (this=0x0) at ../../dw/ui.hh:263
    263	   inline Resource *getResource () { return resource; }
    (gdb) bt
    #0  0x00005555555a4fd6 in dw::core::ui::Embed::getResource (this=0x0) at ../../dw/ui.hh:263
    #1  0x00005555555a43ce in DilloHtmlInput::appendValuesTo (this=0x5555569235b0, values=0x555555929aa0, is_active_submit=false) at ../../src/form.cc:1865
    #2  0x00005555555a29a3 in DilloHtmlForm::buildQueryData (this=0x555556917470, active_submit=0x5555568c6bd0) at ../../src/form.cc:1224
    #3  0x00005555555a251b in DilloHtmlForm::buildQueryUrl (this=0x555556917470, active_input=0x5555568c6bd0) at ../../src/form.cc:1142
    #4  0x00005555555a23bf in DilloHtmlForm::submit (this=0x555556917470, active_input=0x5555568c6bd0, event=0x7fffffffcec0) at ../../src/form.cc:1102
    #5  0x00005555555a40ba in DilloHtmlInput::activate (this=0x5555568c6bd0, form=0x555556917470, num_entry_fields=2, event=0x7fffffffcec0) at ../../src/form.cc:1798
    #6  0x00005555555a229f in DilloHtmlForm::eventHandler (this=0x555556917470, resource=0x555555cb7c00, event=0x7fffffffcec0) at ../../src/form.cc:1079
    #7  0x00005555555a3db9 in DilloHtmlReceiver::clicked (this=0x555555929030, resource=0x555555cb7c00, event=0x7fffffffcec0) at ../../src/form.cc:1707
    #8  0x0000555555617888 in dw::core::ui::Resource::ClickedEmitter::emitToReceiver (this=0x555555cb7c20, receiver=0x555555929040, signalNo=0, argc=2, argv=0x7fffffffce50)
        at ../../dw/ui.cc:301
    #9  0x000055555562102e in lout::signal::Emitter::emitVoid (this=0x555555cb7c20, signalNo=0, argc=2, argv=0x7fffffffce50) at ../../lout/signal.cc:81
    #10 0x000055555561790e in dw::core::ui::Resource::ClickedEmitter::emitClicked (this=0x555555cb7c20, resource=0x555555cb7c00, event=0x7fffffffcec0) at ../../dw/ui.cc:312
    #11 0x00005555555fd255 in dw::core::ui::Resource::emitClicked (this=0x555555cb7c00, event=0x7fffffffcec0) at ../../dw/ui.hh:354
    #12 0x00005555555fa65a in dw::fltk::ui::FltkLabelButtonResource::widgetCallback (widget=0x55555674a090, data=0x555555cb7c00) at ../../dw/fltkui.cc:709
    #13 0x00007ffff76f5ac8 in Fl_Widget::do_callback(Fl_Widget*, void*) () from /usr/lib/libfltk.so.1.3
    #14 0x000055555557b973 in Fl_Widget::do_callback (this=0x55555674a090) at /usr/include/fltk1.3/FL/Fl_Widget.H:861
    #15 0x00005555555fa2c8 in dw::fltk::ui::EnterButton::handle (this=0x55555674a090, e=8) at ../../dw/fltkui.cc:620
    #16 0x00007ffff7690f85 in ?? () from /usr/lib/libfltk.so.1.3
    #17 0x00007ffff7693a6d in Fl::handle_(int, Fl_Window*) () from /usr/lib/libfltk.so.1.3
    #18 0x00007ffff76ffd8c in fl_handle(_XEvent const&) () from /usr/lib/libfltk.so.1.3
    #19 0x00007ffff76f5272 in ?? () from /usr/lib/libfltk.so.1.3
    #20 0x00007ffff76f55bd in fl_wait(double) () from /usr/lib/libfltk.so.1.3
    #21 0x00007ffff76930de in Fl::wait(double) () from /usr/lib/libfltk.so.1.3
    #22 0x00007ffff7693213 in Fl::wait() () from /usr/lib/libfltk.so.1.3
    #23 0x0000555555564163 in main (argc=2, argv=0x7fffffffd7c8) at ../../src/dillo.cc:619

It seems to be happening when trying to login into https://www.amazon.com (I
don't think the login will work, but we should not crash). Likely introduced by
#433.

We need to handle the case in which we are submitting a form with non-displayed
elements as they currently don't have an embed or resource.
