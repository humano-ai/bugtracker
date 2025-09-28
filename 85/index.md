Title: Consider integrating the RTFL library into Dillo
Author: rodarima
Created: Mon, 26 Feb 2024 23:03:06 +0000
State: closed

Sebastian Geerken developed the RTFL library to ease the debugging of Dillo:

> RTFL, which stands for "Read The Figurative Logfile", is a both a
protocol for structured debug messages, as well as a collection of
programs (currently two) displaying these debug messages in a
semi-graphical way, so that it becomes simpler to determine what the
debugged program does.
>
> Programs are prepared to print these special debug messages to
standard output, which are then passed to a viewer program like
"rtfl-objcount" or "rtfl-objview".


It is stored on the web archive: https://web.archive.org/web/20170310013459/http://home.gna.org/rtfl

Here is an snapshot from Sebastian:

![image](https://github.com/dillo-browser/dillo/assets/3866127/a3ec1651-62ff-41f2-92b5-a55ac1fbb686)


I'll also upload it here to save a copy: [rtfl-0.1.1.tar.gz](https://github.com/dillo-browser/dillo/files/14412264/rtfl-0.1.1.tar.gz)

Dillo must be configure with `--enable-rtfl` to use it.


--%--
From: rodarima
Date: Tue, 10 Dec 2024 22:04:03 +0000

Uploaded to https://github.com/dillo-browser/rtfl

There is no need to add it to Dillo repository, we can keep it in its own.