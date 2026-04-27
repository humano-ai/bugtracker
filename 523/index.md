Title: Wikipedia returning 429 for some images
Author: Rodrigo Arias Mallo
Created: Mon, 27 Apr 2026 19:49:10 +0200
State: open

When navigating to 
<https://en.wikipedia.org/wiki/Berkeley_Software_Distribution>
with the `trace_http` option enabled, I can see that is failing to load some
images:

    % dillo https://en.wikipedia.org/wiki/Berkeley_Software_Distribution
    ...
    <<< receiving HTTP:
    HTTP/1.1 200 OK
    content-type: image/jpeg
    content-disposition: inline;filename*=UTF-8''SunOS_4.1.1_P1270750.jpg
    etag: e46c861d769dc23346e063618a7e1585
    last-modified: Sun, 26 Apr 2026 12:30:54 GMT
    content-length: 15315
    date: Mon, 27 Apr 2026 11:48:42 GMT
    server: envoy
    age: 21732
    accept-ranges: bytes
    x-cache: cp6002 hit, cp6007 hit/2
    x-cache-status: hit-front
    server-timing: cache;desc="hit-front", host;desc="cp6007"
    strict-transport-security: max-age=106384710; includeSubDomains; preload
    report-to: { "group": "wm_nel", "max_age": 604800, "endpoints": [{ "url": "https://intake-logging.wikimedia.org/v1/events?stream=w3c.reportingapi.network_error&schema_uri=/w3c/reportingapi/network_error/1.0.0" }] }
    nel: { "report_to": "wm_nel", "max_age": 604800, "failure_fraction": 0.05, "success_fraction": 0.0}
    x-client-ip: xxx
    x-content-type-options: nosniff
    access-control-allow-origin: *
    access-control-expose-headers: Age, Date, Content-Length, Content-Range, X-Content-Duration, X-Cache
    timing-allow-origin: *
    set-cookie: WMF-Uniq=xxx;Domain=upload.wikimedia.org;Path=/;HttpOnly;secure;SameSite=None;Expires=Tue, 27 Apr 2027 00:00:00 GMT
    x-request-id: b70318b7-c9a4-4c70-af4d-02228a5eb39c
    x-analytics:


    >>> sending HTTP:
    GET /wikipedia/commons/thumb/f/fa/Wikiquote-logo.svg/40px-Wikiquote-logo.svg.png HTTP/1.1\x0D
    Host: upload.wikimedia.org\x0D
    User-Agent: Dillo/3.3.0\x0D
    Accept: image/png,image/*;q=0.8,*/*;q=0.5\x0D
    Accept-Language: en-US\x0D
    Accept-Encoding: gzip, deflate, br\x0D
    DNT: 1\x0D
    Connection: keep-alive\x0D
    \x0D

    <<< receiving HTTP:
    HTTP/1.1 429 Too many requests (76af2b0)
    date: Mon, 27 Apr 2026 17:50:54 GMT
    server: Varnish
    x-cache: cp6007 int
    x-cache-status: int-front
    server-timing: cache;desc="int-front", host;desc="cp6007"
    strict-transport-security: max-age=106384710; includeSubDomains; preload
    report-to: { "group": "wm_nel", "max_age": 604800, "endpoints": [{ "url": "https://intake-logging.wikimedia.org/v1/events?stream=w3c.reportingapi.network_error&schema_uri=/w3c/reportingapi/network_error/1.0.0" }] }
    nel: { "report_to": "wm_nel", "max_age": 604800, "failure_fraction": 0.05, "success_fraction": 0.0}
    x-client-ip: xxx
    access-control-allow-origin: *
    access-control-expose-headers: Age, Date, Content-Length, Content-Range, X-Content-Duration, X-Cache
    timing-allow-origin: *
    retry-after: 1
    content-type: text/html; charset=utf-8
    content-length: 1966
    x-request-id: e73efc61-e84e-45bd-b74b-13ffde2f014d
    x-analytics:


    HTTP warning: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/4.3_BSD_UWisc_VAX_Emulation_Lisp_Manual.png/250px-4.3_BSD_UWisc_VAX_Emulation_Lisp_Manual.png' cannot be displayed as image; has media type 'text/html; charset=utf-8'

Could this be occurring because we are using too many parallel connections? The
limit is currently 6 per host:

    % grep http_max_conns src/prefs.c
       prefs.http_max_conns = 6;

    % grep max_conn ~/.dillo/dillorc
    http_max_conns=6
    % dillo https://en.wikipedia.org/wiki/Berkeley_Software_Distribution &> log.txt
    % grep -c '^HTTP/1.1 429' log.txt
    7

Same with 2:

    % grep max_conn ~/.dillo/dillorc
    http_max_conns=2
    % dillo https://en.wikipedia.org/wiki/Berkeley_Software_Distribution &> log.txt
    % grep -c '^HTTP/1.1 429' log.txt
    7

So it doesn't seem to be that.

All images load properly on Firefox via HTTP/2.

From <https://phabricator.wikimedia.org/T413570#11494643>:

> Ah! I resolved the 429 issue on my end. My webapp uses Helmet.js, which
> defaults to hiding the Referer header when loading external files. I started
> allowing the Referer header to be sent when loading upload.wikimedia.org
> images and images are loading fine again (and I'm now back to using
> upload.wikimedia.org instead of thumb.php). I'm guessing with whatever recent
> changes were done to keep AI scrapers at bay, the Referer header became a more
> important heuristic.

The same results are obtained when setting the Referer header to the host, path
or none.

Is this just another AI scrapping side-effect?
More here <https://www.mediawiki.org/wiki/Wikimedia_APIs/Rate_limits>:

> Requests made from a web browser by an unauthenticated user: 200 req/min

So, that would allow us to do 3.3 requests per second, so we are likely
exceeding this limit for the images. Perhaps we can add Dillo to the list of
blessed User-Agents.

The limit to be caused by AI scraping:
<https://diff.wikimedia.org/2025/04/01/how-crawlers-impact-the-operations-of-the-wikimedia-projects/>

Reached of to Wikimedia.
