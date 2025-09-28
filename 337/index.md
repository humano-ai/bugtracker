Title: [Dpi_read_comm_keys] No such file or directory on Cygwin
Author: niutech
Created: Tue, 14 Jan 2025 13:15:02 +0000
State: closed

When I run `dillo data:text/html,Hello%2C%20World` version 3.2.0-rc1 in Cygwin I get the following output:
```
Domain: Default accept.
dillo_dns_init: Here we go! (threaded)
TLS library: mbed TLS 2.23.0
Trusting 148 TLS certificates.
Disabling cookies.
Nav_open_url: new url='data:text/html,Hello%2C%20World'
** ERROR **: [Dpi_read_comm_keys] No such file or directory
Dpi_check_dpid: check_st=-1
Dpi_check_dpid: EAGAIN
Dpi_blocking_start_dpid: try 1
[dpid]: a_Misc_mksecret: e4d94003
dpid started
Dpi_check_dpid: check_st=1
Dpi_check_dpid: OK
Dpi_get_server_port: server_name = [proto.data]
[<cmd='check_server' msg='proto.data' '>]
Dpi_get_server_port: can't read server port from dpid.
Dpi_connect_socket: can't get port number for proto.data
```
Now there is a file `~/.dillo/dpid_comm_keys` with the following contents: `5020 e4d94003` but Dillo doesn't load anything.
After Dillo restart, the window is still blank and this is the console output:
```
Domain: Default accept.
dillo_dns_init: Here we go! (threaded)
TLS library: mbed TLS 2.23.0
Trusting 148 TLS certificates.
Disabling cookies.
Nav_open_url: new url='data:text/html,Hello%2C%20World'
Dpi_check_dpid: check_st=1
Dpi_check_dpid: OK
Dpi_get_server_port: server_name = [proto.data]
[<cmd='check_server' msg='proto.data' '>]
Dpi_get_server_port: can't read server port from dpid.
Dpi_connect_socket: can't get port number for proto.data
```
The port 5020 is opened, which is seen by `netstat`:
```
Active Connections

  Proto  Local Address          Foreign Address        State
  TCP    127.0.0.1:5020         PC:65373             TIME_WAIT
```

--%--
From: rodarima
Date: Wed, 15 Jan 2025 19:31:35 +0000

> Dpi_connect_socket: can't get port number for proto.data

It looks dpid cannot find the data: builtin plugin. What is the value of dpi_dir in ~/.dillo/dpidrc? https://dillo-browser.github.io/user_help.html#dpidrc

--%--
From: niutech
Date: Thu, 16 Jan 2025 09:50:07 +0000

Here is `~/.dillo/dpidrc`:
```
dpi_dir=/usr/local/lib/dillo/dpi

proto.file=file/file.dpi.exe
proto.ftp=ftp/ftp.filter.dpi.exe
proto.data=datauri/datauri.filter.dpi.exe
```
And here is `ls /usr/local/lib/dillo/dpi/`:
```
bookmarks  cookies  datauri  downloads  file  ftp  hello  vsource
```


--%--
From: rodarima
Date: Thu, 16 Jan 2025 21:55:58 +0000

I cannot reproduce this with 3.2.0-rc1 (from git or the tarball) following the [install instructions for cygwin](https://github.com/dillo-browser/dillo/blob/master/doc/install.md#windows-via-cygwin):

![Image](https://github.com/user-attachments/assets/474b410d-6dae-492b-ad20-0b19532c3f5f)

Not sure how you are getting these lines, they don't appear on my Dillo 3.2.0-rc1:

```
Dpi_check_dpid: check_st=1
Dpi_check_dpid: OK
Dpi_get_server_port: server_name = [proto.data]
[<cmd='check_server' msg='proto.data' '>]
```

Do you have more than one Dillo installed? Can you open the bookmarks?

Does the issue persist after `dpidc stop`?

If so, please add the instructions to reproduce from source step by step. Send also the output of `dillo -v` and your config.log file (from the build directory).

--%--
From: niutech
Date: Thu, 16 Jan 2025 22:20:01 +0000

Yes, the issue persists after `dpidc stop`. I see just the blank page and `Dpi_get_server_port: can't read server port from dpid.`

I've built dillo from the HEAD of git repo. These extra lines are from replacing `_MSG` macro with `MSG` in `src/IO/dpi.c` for debugging.

The build instructions were pretty standard: `./autogen.sh && ./configure --prefix=/usr/local && make && make install`

I cannot open bookmarks neither. The output is:
```
Nav_open_url: new url='dpi:/bm/'
Dpi_check_dpid: check_st=1
Dpi_check_dpid: OK
Dpi_get_server_port: server_name = [bookmarks]
[<cmd='check_server' msg='bookmarks' '>]
Dpi_get_server_port: can't read server port from dpid.
Dpi_connect_socket: can't get port number for bookmarks
```

`ps aux` shows running `/usr/local/bin/dpid`. File `~/.dillo/dpid_comm_keys` contains `5020 6faa6c1e`.


`dillo -v` is:
```
Dillo v3.2.0-rc1-dirty
Libraries: fltk/1.3.8 zlib/1.3.1 jpeg/3.1.0 png/1.6.42 mbedTLS/2.23.0
Features: +GIF +JPEG +PNG +SVG -WEBP +XEMBED +TLS
```

Maybe I should remove dillo altogether and rebuild it from scratch? 

--%--
From: rodarima
Date: Thu, 16 Jan 2025 22:30:17 +0000

Hmm, can you run `dpidc stop` to stop dpid and then from another window run `strace -f dpid` manually? Then try again to open dillo. The trace should tell us what is happening with dpid.

> Maybe I should remove dillo altogether and rebuild it from scratch?

That may get rid of the issue, but I don't know what is happening yet.

--%--
From: niutech
Date: Thu, 16 Jan 2025 22:39:35 +0000

[Here](https://privatebin.net/?63762a407b69b9c4#HsNP5k7mk7trZ1HM6cqcrto9jpA8fbdkGKWEhP9XFRWU) is the strace log when opening `dillo data:text/html,Hello%2C%20World`.

I can see there `__set_winsock_errno: recv_internal:1232 - winsock error 10035 -> errno 11` which is described as:

> WSAEWOULDBLOCK: Resource temporarily unavailable.
> This error is returned from operations on nonblocking sockets that cannot be completed immediately, for example [recv](https://learn.microsoft.com/en-us/windows/desktop/api/winsock/nf-winsock-recv) when no data is queued to be read from the socket. It is a nonfatal error, and the operation should be retried later. It is normal for WSAEWOULDBLOCK to be reported as the result from calling [connect](https://learn.microsoft.com/en-us/windows/desktop/api/Winsock2/nf-winsock2-connect) on a nonblocking SOCK_STREAM socket, since some time must elapse for the connection to be established.

--%--
From: rodarima
Date: Thu, 16 Jan 2025 23:11:46 +0000

Before that, dpid will try to scan all dpis available. Is it possible it is failing to opendir /usr/local/lib/dillo/dpi/ ?

>  180 1923424 [main] dpid 2028 __set_errno: DIR* opendir(const char*):67 setting errno 2

You may want to put some extra MSG lines in the dpid code: https://github.com/dillo-browser/dillo/blob/master/dpid/dpid.c#L233

It should first scan the dpi directory to register all plugins, and then use that table to find which dpi needs to spawn. Let's check first that it is properly finding the datauri dpi.

```diff
diff --git a/dpid/dpid.c b/dpid/dpid.c
index 9bf28f46..9639432f 100644
--- a/dpid/dpid.c
+++ b/dpid/dpid.c
@@ -239,6 +239,8 @@ int get_dpi_attr(char *dpi_dir, char *service, struct dp *dpi_attr)
    DIR *dir_stream;
    struct dirent *dir_entry = NULL;

+   MSG("get_dpi_attr(dpi_dir=%s, service=%s, ...)\n", dpi_dir, service);
+
    service_dir = dStrconcat(dpi_dir, "/", service, NULL);
    if (stat(service_dir, &statinfo) == -1) {
       ERRMSG("get_dpi_attr", "stat", errno);
@@ -276,6 +278,8 @@ int get_dpi_attr(char *dpi_dir, char *service, struct dp *dpi_attr)
       if (ret != 0)
          MSG_ERR("get_dpi_attr: No dpi plug-in in %s/%s\n",
                  dpi_dir, service);
+      else
+         MSG("get_dpi_attr: %s OK\n", service);
    }
    dFree(service_dir);
    return ret;

```

Check that you see the lines:

```
[dpid]: get_dpi_attr(dpi_dir=/usr/local/lib/dillo/dpi, service=datauri, ...)
[dpid]: get_dpi_attr: datauri OK
```

When running the new `dpid`.

--%--
From: niutech
Date: Thu, 16 Jan 2025 23:49:21 +0000

I've added these MSG and rebuilt, but when I run `dpid`, I get only:
```
[dpid]: a_Misc_mksecret: c44d0303
dpid started
```
like `get_dpi_attr` wasn't invoked at all on start. Moreover, `register_service` and `get_command` neither.

Only when I open `dillo data:text/html,Hello%2C%20World`, I get:
```
[dpid]: get_command(dpi_tag=null)
[dpid]: get_command(dpi_tag=<cmd='check_server' msg='proto.data' '>)
```
but no `register_service` nor `register_all` commands are invoked.

Also, `numdpis` is 0 in `main`.

--%--
From: niutech
Date: Fri, 17 Jan 2025 00:44:12 +0000

Bingo! I've added a symlink `ln -s /usr/local/lib/dillo/dpi/ ~/.dillo/` and now it works!

![Dillo showing data: URI](https://github.com/user-attachments/assets/630bf21e-b8d4-498f-9c17-77dcb62c031c)

It is searching for services in ~`~/.dillo/dpi` directory (`get_dpi_attr(dpi_dir=~/.dillo/dpi)`) even though in my `~/.dillo/dpidrc` there is:
```
dpi_dir=/usr/local/lib/dillo/dpi
```
The problem is in `register_all` function, it should register services from my `dpi_dir`, not `~/.dillo/dpi` directory.

--%--
From: rodarima
Date: Fri, 17 Jan 2025 09:56:43 +0000

I suspect there is something wrong with your /usr/local/lib/dillo/dpi path. You could try installing dillo in some other prefix like ~/usr and see if the issue persist. On the other hand I think we should emit some message when we cannot open the system path of dpis, see the opendir here:

https://github.com/dillo-browser/dillo/blob/f10a7800efa7c3a8017878e6e998ecf7b32d8e86/dpid/dpid.c#L399-L410

> It is searching for services in ~~/.dillo/dpi directory (get_dpi_attr(dpi_dir=~/.dillo/dpi)) even though in my ~/.dillo/dpidrc there is:

Dillo searches in your home AND in the system dpi_dir directory set in dpidrc for plugins. The latter is the one that includes the datauri plugin. It should search in both places.

--%--
From: rodarima
Date: Fri, 17 Jan 2025 20:19:13 +0000

I have added another error message to determine if there was a problem opening the dpi directory in PR https://github.com/dillo-browser/dillo/pull/339. I reproduced your sympthoms by removing the read access to the system dpi directory, which now complains and also reports how many plugins it has loaded:

```
% dpid/dpid
[dpid]: cannot open system dpi directory '/usr/local/lib/dillo/dpi': Permission denied
[dpid]: a_Misc_mksecret: xxxx
dpid started (found 0 dpis)
```

If you can reproduce this on your end, chances are that dpid is not able to read the `/usr/local/lib/dillo/dpi` directory.

--%--
From: rodarima
Date: Sat, 25 Jan 2025 14:07:47 +0000

Closing for now, reopen if the issue persist and you want to further track it down.