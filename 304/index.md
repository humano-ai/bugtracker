Title: Images not loading for HTTP redirects
Author: rodarima
Created: Tue, 19 Nov 2024 08:37:24 +0000
State: open

Loading the website causes the images not to display. But following a link and
then going back causes the images to properly load.

Reported-by: Flea86

--%--
From: rodarima
Date: Tue, 19 Nov 2024 20:07:05 +0000

Reproducer:

```html
<img src="http://hackaday.com/wp-content/uploads/2011/11/pic.jpg">
```

The image returns a 301 redirect:

```
GET /wp-content/uploads/2011/11/pic.jpg HTTP/1.1
Host: hackaday.com
User-Agent: Dillo/3.1.1
Accept: image/png,image/*;q=0.8,*/*;q=0.5
Accept-Encoding: gzip, deflate
DNT: 1
Referer: http://hackaday.com/
Connection: keep-alive


HTTP/1.1 301 Moved Permanently
Server: nginx
Date: Tue, 19 Nov 2024 19:42:16 GMT
Content-Type: text/html
Content-Length: 162
Connection: keep-alive
Location: https://hackaday.com/wp-content/uploads/2011/11/pic.jpg
cache-control: max-age=31536000
x-rq: mad1 

<html>
<head><title>301 Moved Permanently</title></head>
<body>
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

Dillo seems to ignore redirects on non-root requests like images:

https://github.com/dillo-browser/dillo/blob/f3103cc4b6c369da96c7de487214a9e56eca755d/src/cache.c#L1240-L1242

Also:

https://github.com/dillo-browser/dillo/blob/f3103cc4b6c369da96c7de487214a9e56eca755d/src/cache.c#L1102-L1107

This predates the git history (2007), so I don't know the context at which this
was done. It looks simply unfinished.

--%--
From: kaimac1
Date: Tue, 03 Dec 2024 16:11:17 +0000

I was just looking at the old site and saw that this behaviour is described as
intentional:

> If Dillo requests an image and receives a response containing a redirection
> (i.e., pointing to a different URL), the redirection is not followed. These
> have a strong tendency to be advertisements.

https://dillo-browser.github.io/old/FAQ.html#q28

--%--
From: Rodrigo Arias Mallo
Date: Sat, 25 Apr 2026 18:38:02 +0200

Another case is tilde.zone where the images are hosted at blob.jortage.com:

    % curl -sI https://media.tilde.zone/accounts/avatars/110/702/530/752/342/503/original/37a30bf039ff6f46.png
    HTTP/2 301
    server: nginx/1.26.3
    ...
    location: https://blob.jortage.com/blob2/RUTXnM2GDfhW-lR_/ZIpKlIexGJOYuDPHSVUy8ZupgseorCa3a4jrmGRVv_W31cq2XBXmaUVQV7EU41/oROj5s2w.png

Reported-by: `the_jmcs`
