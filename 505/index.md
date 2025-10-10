Title: Leftover files after make uninstall
Author: Rodrigo Arias Mallo
Created: Fri, 10 Oct 2025 23:27:17 +0200
State: open

We leave some directories after running make uninstall:

    % make install && make uninstall
    ...
    % cd install && find *                                 
    bin
    etc
    etc/dillo
    lib
    lib/dillo
    lib/dillo/dpi
    lib/dillo/dpi/downloads
    lib/dillo/dpi/file
    lib/dillo/dpi/hello
    lib/dillo/dpi/datauri
    lib/dillo/dpi/cookies
    lib/dillo/dpi/ftp
    lib/dillo/dpi/bookmarks
    lib/dillo/dpi/vsource
    share
    share/applications
    share/icons
    share/icons/hicolor
    share/icons/hicolor/48x48
    share/icons/hicolor/48x48/apps
    share/icons/hicolor/128x128
    share/icons/hicolor/128x128/apps
    share/man
    share/man/man1
    share/doc
    share/doc/dillo

Reported by koutsie via IRC.
