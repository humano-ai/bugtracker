Title: Adhere to XDG base directory specification
Author: joshas
Created: Sat, 23 Nov 2024 20:06:38 +0000
State: closed

A minor nitpick, but it would be great if Dillo stored configuration files adhering to [XDG base directory specification](https://specifications.freedesktop.org/basedir-spec/latest/). Instead of creating directory `.dillo` directly in $HOME directory, application should keep it in `$HOME/.config/dillo`.
This is useful, as all configs end up in single directory and it is easier to backup everything, not picking by single directory. Also, cleaner $HOME :)

[FLTK fixed this issue in 1.4 release](https://www.fltk.org/str.php?L3370), so I'd expect this fix happening only after Dillo upgrades to latest version of FLTK.

--%--
From: rodarima
Date: Sat, 23 Nov 2024 21:10:27 +0000

Not a huge fan of typing `.config/dillo/dillorc` every time I need to change the config.

Maybe `ln -s .config/dillo .dillo` ?

This is independent of FLTK, but I don't see that many benefits as to compensate the pain it would take to implement an maintain.

--%--
From: philocalyst
Date: Sat, 21 Dec 2024 19:05:30 +0000

Would say there is a great deal more nuance to this issue than just convenience to reach, Very much valued and a boon for user choice -- I would view this as a general step towards a greater compatibility with various user expectations. If you are comfortable letting it be in your home directory, you can set that! Approached the right way, this would make the codebase more robust if anything.

Making it default is another discussion, but adding this variable is not something to be dismissed.