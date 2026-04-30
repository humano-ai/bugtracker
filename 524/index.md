Title: Dillo is getting close to the floppy disk capacity
Author: Rodrigo Arias Mallo
Created: Tue, 28 Apr 2026 22:17:08 +0200
State: open

For the [3.3.0 release][3.3.0], we are at the 95% capacity of a floppy disk with
the gzip compression.

[3.3.0]: https://dillo-browser.org/release/3.3.0/

With a bit of awk we can see the relative size increase with respect to the
floppy disk:

    % ls -ltr */*.tar.gz | grep -v rc | sed 's,/, ,' | \
        awk '{s=$5; v=$9; r=s/14417.92; d=R?r-R:0; \
        printf "%s  %d  %.2f%%  %+.2f%%\n", v, s, r, d; R=r }'

    3.1.0  1198855  83.15%  +0.00%
    3.1.1  1253223  86.92%  +3.77%
    3.2.0  1324311  91.85%  +4.93%
    3.3.0  1368668  94.93%  +3.08%

We have been steadily increasing the size of the release by about 4% since
3.1.0.

We can always switch to a more efficient compression method, but I would like to
be able to distribute the gzip tarball in the floppy. We should start looking
for stuff to clean, so we can make room for new code. 

--%--
From: Rodrigo Arias Mallo
Date: Thu, 30 Apr 2026 20:24:11 +0200

From the tarball we can estimate the largest contributions to the release size
from the file size (not always correlated):

    % tar tvf dillo-3.3.0.tar.gz | sort -nrk3 | head -20 |\
        awk '{gsub(/dillo-3.3.0\//, ""); print $3, $6}' | column -t
    306779  configure
    196387  src/hsts_preload
    144496  src/html.cc
    119085  dw/textblock.cc
    112256  ChangeLog
    103149  Doxyfile
    94920   test/unit/hyph-de.pat
    87462   dw/textblock_linebreaking.cc
    86441   src/nanosvg.h
    76104   dw/widget.cc
    64032   src/form.cc
    56521   dw/table.cc
    56487   src/cssparser.cc
    54562   src/html_charrefs.h
    50951   dw/style.cc
    50726   config.guess
    49710   src/cache.c
    49295   dw/Makefile.in
    49272   test/dw/Makefile.in
    49197   aclocal.m4

The easy one is the `Doxyfile` which we can just prune to the relevant options.
The `hsts_preload` is outdated and using a new version will increase the size of
the release to several MiB. We can get rid of it by using the opposite set,
where we just add exception to those sites that could be reached via HTTP (see
[412](/412)).

We could also remove or trim the hyphenation pattern files, as they are only
used for the unit test. We can just use the ones provided by hyphen.

Let's try to bring the size down to 90% of the floppy disk as a first target,
and then we can see if it makes sense to invest more effort.

Trimming the `Doxyfile` only lowers the size to 1341224 bytes, so we end up with
93.02% occupation (1.90% less).

We still need to remove more stuff.

Let's make a test by removing all entries in the `hsts_preload` file and see
what the size is. The size is 1273329 bytes, so 88.32% of the floppy (4.7%
lower). This seems to be the best way forward.
