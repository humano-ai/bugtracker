Title: Evaluate native Windows and DOS support
Author: Rodrigo Arias Mallo
Created: Tue, 16 Dec 2025 16:05:46 +0100
State: open

Given the work done by Benjamin Johnson around 2010 and 2013 to port Dillo to
Windows and DOS, it may be worth evaluating if it would be doable to merge
patches into mainline, so we at least can build Dillo natively in Windows.

<https://sourceforge.net/projects/dplus-browser/>

From the README:

    3. Compatibility
    ----------------

      - Microsoft Windows 95, 98, Me, NT 4.0, 2000, XP, Vista, and 7,
        including all x64 versions.

      - Microsoft Windows NT 3.51, using a specialized build.

      - DOS and compatible systems (tested mainly on MS-DOS 6.22 and FreeDOS).

      - All recent Linux/Unix systems.  Linux binary packages are available
        for current CentOS, Debian, Fedora, openSUSE, RHEL, and Ubuntu releases.

      - Mac OS X should work, but has not been tested by the developer.
        Mainline Dillo has been reported to run fine.

      - Theoretically any other platform with a sockets library and FLTK 1.3.

I don't think it would be possible to guarantee that support on those platforms
won't be broken, but it may be doable to support them on a best-effort basis. It
seems that MinGW can cross compile Dillo for Windows from a UNIX machine, which
would be enough for us.
