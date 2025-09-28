Title: Ensure Dillo fits in a floppy disk
Author: rodarima
Created: Sat, 29 Jun 2024 10:39:47 +0000
State: closed

One of the ways in which we can test we don't add too much complexity to Dillo is to limit the size of the release. As it is currently around 1 MiB, I though a good limit would be a [3½-inch floppy disk of 1.44 MB](https://en.wikipedia.org/wiki/Floppy_disk#3%C2%BD-inch_disk) (actually 1440 KiB = 1.41 MiB). That would be 1474560 bytes.

As we already make the distributable releases, we only need to check the file size. Compression algorithms will produce different sizes, but let see if we can manage with gzip or bzip2, which are widely available.