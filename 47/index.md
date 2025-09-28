Title: Add command line tool to control the browser
Author: rodarima
Created: Sat, 30 Dec 2023 21:03:51 +0000
State: open

In order to run the tests without human interaction, we need a way to drive the browser and perform some actions programmatically. These actions could be performed with a command line utility `dillocli` that connects to the dpid server. Here are some examples:

- `dillocli open https://google.com/`: Open a new page.
- `dillocli wait [5s]`: Wait until the current page has loaded fully (maybe with a timeout).
- `dillocli geometry 100x100`: Get and change the window geometry (to test the page wrapping).
- `dillocli click submit-btn`: Click the element with the given id with the mouse.
- `dillocli hover submit-btn`: Hover the element with the given id with the mouse.
- `dillocli tls`: Get TLS information from the current page (required to test bad certificates, expired ones...).

--%--
From: crisdosaygo
Date: Wed, 03 Jan 2024 03:09:38 +0000

This will probably sound evil (because it mentions Chrome) which would seem to run counter to your project's more benevolent goals, but would it be a terrible idea to support a subset of [CDP](https://chromedevtools.github.io/devtools-protocol/tot/)? 

I [use](https://github.com/BrowserBox/BrowserBox/blob/4312247a3b949068a65ad1b1b7d3bcf900bf0db0/src/zombie-lord/connection.js#L381) this protocol for [BrowserBox](https://github.com/BrowserBox/BrowserBox) and it's just so useful. If you want a breakdown on how to understand it and work with it I'm happy to provide you that. 

I'm sure enabling CDP seems sorta like selling out. But it doesn't mean selling out, it just means speaking a common language -- sorta like HTML -- but from a developer point of view! 😄  And it's not just Cr-based browsers that use CDP, all the big ones do: even Safari and Firefox support subsets which enables them to be automated and instrumented! 

I really think it's the way to go not only for tests, but if you add CDP then tools like [pptr](https://pptr.dev/) and [playwright](https://github.com/microsoft/playwright) will be able to use Dillo, which could be a route to greatly expand its adoption, help more people contribute and get involved and generally support its goals of lowering barriers to entry by supporting older hardware and slower links!

Regardless, the command-line tool to control the browser is a great idea and I think your current approach to creating an eloquent API (`dillocli <cmd> <selector | args>`) is gorgeous! Anyway sure you're super busy and totally get if you too busy to reply or if anything else make CDP support impossible for you -- no worries at all! -- just thanks for reading this far!

--%--
From: rodarima
Date: Wed, 03 Jan 2024 16:03:02 +0000

> This will probably sound evil (because it mentions Chrome) which would seem to run counter to your project's more benevolent goals, but would it be a terrible idea to support a subset of [CDP](https://chromedevtools.github.io/devtools-protocol/tot/)?

I checked a bit of the details:

```
{"cmd":"Page.captureScreenshot","args":{"format": "jpeg"}}
```
And https://chromedevtools.github.io/devtools-protocol/tot/Page/#method-navigate

But it looks gigantic, complex and full of experimental features. Keep in mind that Dillo doesn't even have a JSON parser.

> I [use](https://github.com/BrowserBox/BrowserBox/blob/4312247a3b949068a65ad1b1b7d3bcf900bf0db0/src/zombie-lord/connection.js#L381) this protocol for [BrowserBox](https://github.com/BrowserBox/BrowserBox) and it's just so useful. If you want a breakdown on how to understand it and work with it I'm happy to provide you that.
>
> I'm sure enabling CDP seems sorta like selling out. But it doesn't mean selling out, it just means speaking a common language -- sorta like HTML -- but from a developer point of view! 😄 And it's not just Cr-based browsers that use CDP, all the big ones do: even Safari and Firefox support subsets which enables them to be automated and instrumented!

I see the usefulness of implementing a subset too, but I don't think it would be a good starting point just yet. Currently Dillo already has its own simple protocol (which is friendly to text CLI processing tools) to manage the browser in a similar way (called the DPI protocol), and it would be much less work to expand it a bit to cover the use-cases I was think with the CLI tool.

> I really think it's the way to go not only for tests, but if you add CDP then tools like [pptr](https://pptr.dev/) and [playwright](https://github.com/microsoft/playwright) will be able to use Dillo, which could be a route to greatly expand its adoption, help more people contribute and get involved and generally support its goals of lowering barriers to entry by supporting older hardware and slower links!
> 
> Regardless, the command-line tool to control the browser is a great idea and I think your current approach to creating an eloquent API (`dillocli <cmd> <selector | args>`) is gorgeous! Anyway sure you're super busy and totally get if you too busy to reply or if anything else make CDP support impossible for you -- no worries at all! -- just thanks for reading this far!

Thanks! I will consider it if I see that I need a more complicated protocol so other tools can interoperate.


--%--
From: crisdosaygo
Date: Wed, 03 Jan 2024 17:02:17 +0000

Cool, man. I understand, thanks for your reply. It's really exciting to see where you will go with this, and I fully respect you taking care and stewardship of the Dillo Project! 🩵

> I see the usefulness of implementing a subset too, but I don't think it would be a good starting point just yet. Currently Dillo already has its own simple protocol (which is friendly to text CLI processing tools) to manage the browser in a similar way (called the DPI protocol)

I would love the see documentation on this! Sounds fascinating 🤓 

More generally, I think your approach espoused here of taking just the minimal necessary next steps, and avoiding unnecessary complexity is super sound, and super smart! I totally align with this and understand that decision, and I think it's the sensible way to manage yourself and ensure that you can persist with this project! That is how I handle development of my large projects as well, always pick the simple next step, maximal usefulness for minimal work, it really is the way to go! 👍🏻 ❤️ 

Thanks, again @rodarima best of luck with the Dillo! 😃 

--%--
From: rodarima
Date: Wed, 06 Mar 2024 09:36:45 +0000

I'm leaving these links as references so I don't forget:
- https://w3c.github.io/webdriver/
- https://web-platform-tests.org/writing-tests/

--%--
From: rodarima
Date: Mon, 25 Mar 2024 20:06:36 +0000

More ideas: when interacting with the browser we probably want to do it by using [sessions](https://w3c.github.io/webdriver/#sessions):

```sh
$ dillocli session new
export DILLO_SESSION=1234
$ eval $(dillocli session new)
```
Now all the following commands will act on the same session.

We can use the same technique to launch multiple sessions in parallel by using subshells:

```sh
(
  eval $(dillocli session new)
  dillocli open ...
  ...
  dillocli session end
) &
(
  eval $(dillocli session new)
  dillocli open ...
  ...
  dillocli session end
) &
```