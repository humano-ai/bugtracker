Title: Cannot run DPI plugins on Cygwin
Author: rodarima
Created: Thu, 28 Mar 2024 18:19:14 +0000
State: closed

```
** WARNING **: preferred cursive font "URW Chancery L" not found.
Nav_open_url: new url='file:/'
** ERROR **: [Dpi_read_comm_keys] No such file or directory
[dpid]: get_file_type: Unknown file type for bookmarks.dpi.exe
[dpid]: get_dpi_attr: No dpi plug-in in /usr/local/lib/dillo/dpi/bookmarks
[dpid]: get_file_type: Unknown file type for cookies.dpi.exe
[dpid]: get_dpi_attr: No dpi plug-in in /usr/local/lib/dillo/dpi/cookies
[dpid]: get_file_type: Unknown file type for datauri.filter.dpi.exe
[dpid]: get_dpi_attr: No dpi plug-in in /usr/local/lib/dillo/dpi/datauri
Dpi_blocking_start_dpid: try 1
[dpid]: get_file_type: Unknown file type for downloads.dpi.exe
[dpid]: get_dpi_attr: No dpi plug-in in /usr/local/lib/dillo/dpi/downloads
[dpid]: get_file_type: Unknown file type for file.dpi.exe
[dpid]: get_dpi_attr: No dpi plug-in in /usr/local/lib/dillo/dpi/file
[dpid]: get_file_type: Unknown file type for ftp.filter.dpi.exe
[dpid]: get_dpi_attr: No dpi plug-in in /usr/local/lib/dillo/dpi/ftp
[dpid]: get_file_type: Unknown file type for hello.filter.dpi.exe
[dpid]: get_dpi_attr: No dpi plug-in in /usr/local/lib/dillo/dpi/hello
[dpid]: get_file_type: Unknown file type for vsource.filter.dpi.exe
[dpid]: get_dpi_attr: No dpi plug-in in /usr/local/lib/dillo/dpi/vsource
[dpid]: a_Misc_mksecret: 7ce8fe12
dpid started
Dpi_get_server_port: can't read server port from dpid.
Dillo: normal exit!
```

See https://github.com/cygwinports-extras/dillo/blob/master/3.0.2-exeext.patch