Title: Slow git clone via HTTPS
Author: Rodrigo Arias Mallo
Created: Mon, 06 Oct 2025 00:09:56 +0200
State: open

Cloning the dillo repository via HTTPS causes git not to print anything for a
long time, it then works fine. In contrast, on GitHub it seems to start
providing feedback immediately.

[See thread](https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/thread/TUQINPVQTGTIZESEHEYFIH374AR4DTTQ/?noscript#XUJ6LNP7472ET66HHKLFNDMEOTXIF6HX)
on the mailing list.

Digging a bit into the git protocol, it seems we don't support git protocol
version 2. This is what GitHub replies:

    % curl -isS --user-agent 'git/2.30.2' -H 'Git-Protocol: version=2' \
        'https://github.com/dillo-browser/dillo/info/refs?service=git-upload-pack'
    HTTP/2 200 
    server: GitHub-Babel/3.0
    content-type: application/x-git-upload-pack-advertisement
    content-security-policy: default-src 'none'; sandbox
    expires: Fri, 01 Jan 1980 00:00:00 GMT
    pragma: no-cache
    cache-control: no-cache, max-age=0, must-revalidate
    vary: Accept-Encoding
    date: Sun, 05 Oct 2025 23:06:58 GMT
    x-frame-options: DENY
    strict-transport-security: max-age=31536000; includeSubDomains; preload
    x-github-request-id: D31C:4C38C:39FB37D:2C054F4:68E2FA11

    001e# service=git-upload-pack
    0000000eversion 2
    0028agent=git/github-91d20c657fe1-Linux
    0013ls-refs=unborn
    0027fetch=shallow wait-for-done filter
    0012server-option
    0017object-format=sha1
    0000

But this is what we reply:

    % curl -isS --user-agent 'git/2.30.2' -H 'Git-Protocol: version=2' \
        'https://git.dillo-browser.org/dillo/info/refs?service=git-upload-pack' 
    HTTP/1.1 200 OK
    Server: nginx
    Date: Sun, 05 Oct 2025 23:07:34 GMT
    Content-Type: text/plain; charset=UTF-8
    Transfer-Encoding: chunked
    Connection: keep-alive
    Content-Disposition: inline; filename="info/refs"
    Last-Modified: Sun, 05 Oct 2025 23:05:34 GMT
    Expires: Sun, 05 Oct 2025 23:10:34 GMT
    Strict-Transport-Security: max-age=31536000

    f57e4fe95b2c0cfd2e966bcebdd6d21fd26e71bb        refs/heads/ci
    29a46a2da7e9350a1252e30aea3c8294097f63a4        refs/heads/master
    f48288b62f7e4d1e17cf06796d8738bd01de3746        refs/heads/mouse-back-forward
    3b6ff743f6cd184740d5314409f729ff6ea57165        refs/notes/commits
    ...

The git documentation on protocol 2 states that a server will ignore the request
if it doesn't support it:

<https://git-scm.com/docs/gitprotocol-v2>

> When using the http:// or https:// transport a client makes a "smart"
> info/refs request as described in gitprotocol-http[5] and requests that v2 be
> used by supplying "version=2" in the Git-Protocol header.

Here is a patch that provides support for it.

<https://git.oriole.systems/cgit/log/ui-clone.c?h=git-http-backend&showmsg=1&follow=1>

<https://lists.zx2c4.com/pipermail/cgit/2014-December/002312.html>
