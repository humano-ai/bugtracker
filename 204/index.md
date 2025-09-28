Title: Dillo is changing URL and appending a 0.
Author: rouilj
Created: Mon, 24 Jun 2024 06:17:33 +0000
State: closed

When I try to go to https://rouilj.dynamic -dns.net/demo/. It looks like the server responds with a
200 code and 14k of data. However I never see the data. Instead dillo displays a 403 error by
accessing: https://rouilj.dynamic -dns.net/demo/0. (Just remove the space before the dash to get the
actual url. Just trying to cut down on traffic to the url.)

The site does return a cookie using SameSite that dillo complains about, but it seems to save the
cookie.

Dillo logging does show both urls in a Nav_open_url log line.

Other URL's on the site work. Other browsers  (firefox, chrome, links, w3m) on the original URL operate
correctly as well.

Any ideas on how I can figure out why dillo is "rewriting" and "redirecting" to an invalid URL?

I looked at the docs, the dillo help text and the dillorc. There doesn't seem to be a more verbose
mode I can set. dillorc is the default with no changes. cookiesrc is default accept (but it failed the same way with default deny). ~/.dillo has no other config files.

Thanks.


--%--
From: rodarima
Date: Mon, 24 Jun 2024 10:19:47 +0000

Thanks for the report, it seems to be caused by the meta tag without the redirect URL. Here is a reproducer:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Test empty URL refresh</title>
    <meta http-equiv="Refresh" content="0">
  </head>
  <body>
    <p>Refresh</p>
  </body>
</html>
```

```
% dillo /tmp/meta-redirect.html
dillo_dns_init: Here we go! (threaded)
TLS library: OpenSSL 3.3.0 9 Apr 2024
Enabling cookies as from cookiesrc...
Nav_open_url: new url='file:/tmp/meta-redirect.html'
...
Nav_open_url: new url='file:/tmp/0'
```
I'll see if I can fix the parser.

--%--
From: rouilj
Date: Mon, 24 Jun 2024 14:20:56 +0000

Hello:

In message ***@***.***>,
rodarima writes:

>Thanks for the report, it seems to be caused by the meta tag without
>the redirect URL. Here is a reproducer:
>
>```html
><!DOCTYPE html>
><html>
>  <head>
>    <title>Test empty URL refresh</title>
>    <meta http-equiv="Refresh" content="0">
>  </head>
>  <body>
>    <p>Refresh</p>
>  </body>
></html>
>```

Ah, that makes sense. I was wondering where 0 was comming from. Dillo
is interpreting the refresh delay time as the url value.

>```
>% dillo /tmp/meta-redirect.html
>dillo_dns_init: Here we go! (threaded)
>TLS library: OpenSSL 3.3.0 9 Apr 2024
>Enabling cookies as from cookiesrc...
>Nav_open_url: new url='file:/tmp/meta-redirect.html'
>...
>Nav_open_url: new url='file:/tmp/0'
>```

Yup that's what I saw.

>I'll see if I can fix the parser.

Sounds good. The refresh is part of the technique for detecting if
javascript is available/enabled. See:

  https://wiki.roundup-tracker.org/IsJavascriptAvailable

for details.

This allows the server to replace javascript driven interactions with
native element. For example replace an multiple value autocomplete
widget with a select multiple element.

--
				-- rouilj
John Rouillard
===========================================================================
My employers don't acknowledge my existence much less my opinions.


--%--
From: rodarima
Date: Mon, 24 Jun 2024 17:45:26 +0000

Hi,

>Sounds good. The refresh is part of the technique for detecting if
>javascript is available/enabled. See:
>
>  https://wiki.roundup-tracker.org/IsJavascriptAvailable
>
>for details.
>
>This allows the server to replace javascript driven interactions with
>native element. For example replace an multiple value autocomplete
>widget with a select multiple element.

This would not work in Dillo, even with my proposed patch. It will just 
ignore the meta refresh tag.

You could redirect the page to another URL like this:

<noscript>
<meta http-equiv="Refresh" content="0;URL=https://your.site/demo/?nojs=1">
</noscript>

And then set the cookie when the nojs parameter is set.

Also you can probably load the non-JS version by default, and then 
enhance the site replacing the elements you want (or the whole page) 
when JS is enabled.

Another question is if Dillo should support redirects to the same page 
or not, as these could cause loops.


--%--
From: rouilj
Date: Mon, 24 Jun 2024 21:55:40 +0000

Hello:

In message ***@***.***>,
rodarima writes:
>>Sounds good. The refresh is part of the technique for detecting if
>>javascript is available/enabled. See:
>>
>>  https://wiki.roundup-tracker.org/IsJavascriptAvailable
>>
>>for details.
>>
>>This allows the server to replace javascript driven interactions with
>>native element. [...]
>
>This would not work in Dillo, even with my proposed patch. It will just 
>ignore the meta refresh tag.

So dillo will just ignore the tag if it doesn't explicitly specify the
url?

>You could redirect the page to another URL like this:
>
><noscript>
><meta http-equiv="Refresh" content="0;URL=https://your.site/demo/?nojs=1">
></noscript>
>
>And then set the cookie when the nojs parameter is set.

I did try something similar originally. However modifying the URL
isn't a great UI.

The url that is presented may or may not have query parameters and a
fragment. I have to create the new URL (with @no_js=1) on the server
and preserve the original query args. But IIRC a bigger issue was that
the server doesn't see the fragment. The redirect ended up removing
the fragment from the URL.

Using a refresh content="0" kept the fragment because the browser was
just reusing the current page url and it had access to the fragment.
I didn't find anything documented that specified that was required,
but it worked for the browsers and OS's I tested on.

Also the URL, unlike cookies, can be saved. I prefer to not put
settings like that in the URL where it could end up in a bookmark.

>Also you can probably load the non-JS version by default, and then 
>enhance the site replacing the elements you want (or the whole page) 
>when JS is enabled.

The default supplied web interface works on text based browsers by not
requiring JS. It is very much a web 1.0 application.

However people can redefine the web interface and choose JS first with
a non-js fallback if they wish. IIRC that's the scenario that
IsJavascriptAvailable was trying to solve.

>Another question is if Dillo should support redirects to the same page 
>or not, as these could cause loops.

I would think it should. Other browsers detect redirect loops. I don't
know the mechanism, but think they use some mechanism of checking the
number of times the same url has been redirected to in a row (possibly
within some short period of time). I assume dillo has some method of
detecting redirect loops via 3XX redirects. Maybe that could be used
here pretending a "0" second meta redirect is like a 307 redirect
status?

Redirecting to the same page with a longer period of time is also
useful.  For example the user can set the page I referenced to refresh
after 60 seconds. This makes sure that the list of issues is kept up
to date.

Sorry I don't have any other ideas on how other browsers handle this
valid HTML meta tag.

Have a great week.

--
				-- rouilj


--%--
From: rodarima
Date: Tue, 25 Jun 2024 19:23:46 +0000

Hi,

>So dillo will just ignore the tag if it doesn't explicitly specify the
>url?

Dillo will only try to follow the redirect if the following properties 
are all met:

- It has delay zero
- The destination is not to the same URL
- The current URL doesn't have the URL_SpamSafe flag.
- The new URL is considered safe (doesn't start with "dpi:")

The URL_SpamSafe is set in some cases like for local files and other 
less common cases, but is not very well documented.

When the delay is greater than zero, it will show a message in the top 
of the page to let the user follow the redirect manually.

>>Another question is if Dillo should support redirects to the same page
>>or not, as these could cause loops.
>
>I would think it should. Other browsers detect redirect loops. I don't
>know the mechanism, but think they use some mechanism of checking the
>number of times the same url has been redirected to in a row (possibly
>within some short period of time). I assume dillo has some method of
>detecting redirect loops via 3XX redirects. Maybe that could be used
>here pretending a "0" second meta redirect is like a 307 redirect
>status?
>
>Redirecting to the same page with a longer period of time is also
>useful.  For example the user can set the page I referenced to refresh
>after 60 seconds. This makes sure that the list of issues is kept up
>to date.
>
>Sorry I don't have any other ideas on how other browsers handle this
>valid HTML meta tag.

I opened issue #206 to implement support for redirects controlled by a 
configuration option, so we let the users choose what they want. I will 
leave this issue to focus on the bug that it was redirecting to /0 
because it was parsing the delay as the new url.

I also think it has some good use cases, but not sure if it should be 
enabled by default. For example, some pages create a long list of 
redirects to try to trick the user into being unable to go back 
(easily). On the other hand, having a monitoring page that refreshes 
every minute is a good use case.
