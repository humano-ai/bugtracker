Title: Bad request when using proxy for some hosts
Author: rodarima
Created: Tue, 15 Oct 2024 18:14:29 +0000
State: closed

The following pages:

- https://lite.duckduckgo.com/lite/
- https://www.openbsd.org/
- https://undeadly.org/
- https://why-openbsd.rocks/

Fail with 400 Bad Request when fetched using a HTTP proxy via Tor. The setup is done with privoxy listening as a HTTP proxy at 8118 and tor as socks5 at 9050.

```
privoxy's config (main info is listen-address and the forward-socks5t with a dot at then end of line)

# grep -v '^#' /etc/privoxy/config                                                                                                      
confdir /etc/privoxy
logdir /log
actionsfile match-all.action # Actions that are applied to all sites and maybe overruled later on.
actionsfile default.action   # Main actions file
actionsfile user.action      # User customizations
filterfile default.filter
filterfile user.filter      # User customizations
logfile logfile
listen-address  127.0.0.1:8118
toggle  1
enable-remote-toggle  0
enable-remote-http-toggle  0
enable-edit-actions 0
enforce-blocks 0
buffer-limit 4096
enable-proxy-authentication-forwarding 0
        forward-socks5t   /               127.0.0.1:9050 .
forwarded-connect-retries  0
accept-intercepted-requests 0
allow-cgi-request-crunching 0
split-large-forms 0
keep-alive-timeout 5
tolerate-pipelining 1
socket-timeout 300

tor's config is the default config (listening to 9050 on localhost, cf SOCKSPort) :
# grep -v '^#' /etc/tor/torrc | grep .
Log notice syslog
RunAsDaemon 1
DataDirectory /var/tor
User _tor

so here privoxy listen tor on 9050, and is accessible at localhost:8118
```

It seems to be reproduced on master and 3.1.1, and using OpenSSL as well as mbedtls.

Using curl however can fetch those pages properly:

```
% curl -s --proxy http://localhost:8118  https://lite.duckduckgo.com/lite/ | grep '<title'
  <title>DuckDuckGo</title>
```

Reported-By: mesago

--%--
From: rodarima
Date: Tue, 15 Oct 2024 18:25:59 +0000

We are requesting `GET https://lite.duckduckgo.com/lite/ HTTP/1.1` via the TLS tunnel instead of `GET /lite/ HTTP/1.1`.

Tentative patch:

```diff
diff --git a/src/IO/http.c b/src/IO/http.c
index c7915fc5..f8a1ebb2 100644
--- a/src/IO/http.c
+++ b/src/IO/http.c
@@ -380,7 +380,7 @@ static Dstr *Http_make_content_type(const DilloUrl *url)
 /**
  * Make the http query string
  */
-static Dstr *Http_make_query_str(DilloWeb *web, bool_t use_proxy)
+static Dstr *Http_make_query_str(DilloWeb *web, bool_t use_proxy, bool_t use_tls)
 {
    char *ptr, *cookies, *referer, *auth;
    const DilloUrl *url = web->url;
@@ -397,7 +397,7 @@ static Dstr *Http_make_query_str(DilloWeb *web, bool_t use_proxy)
    const char *connection_hdr_val =
       (prefs.http_persistent_conns == TRUE) ? "keep-alive" : "close";

-   if (use_proxy) {
+   if (use_proxy && !use_tls) {
       dStr_sprintfa(request_uri, "%s%s",
                     URL_STR(url),
                     (URL_PATH_(url) || URL_QUERY_(url)) ? "" : "/");
@@ -485,7 +485,9 @@ static void Http_send_query(SocketData_t *S)
    DataBuf *dbuf;

    /* Create the query */
-   query = Http_make_query_str(S->web, S->flags & HTTP_SOCKET_USE_PROXY);
+   query = Http_make_query_str(S->web,
+                  S->flags & HTTP_SOCKET_USE_PROXY,
+                  S->flags & HTTP_SOCKET_TLS);
    dbuf = a_Chain_dbuf_new(query->str, query->len, 0);

    MSG_BW(S->web, 1, "Sending query%s...",
```