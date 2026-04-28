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
