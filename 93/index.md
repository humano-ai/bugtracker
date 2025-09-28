Title: Add support for the "download" attribute
Author: dirwiz
Created: Thu, 07 Mar 2024 20:28:44 +0000
State: open

Happy to see Dillo active again!  This is just a wish list item, Data URL support would be pretty neat and very low on resource usage.

For reference:
[Wikipedia](https://en.wikipedia.org/wiki/Data_URI_scheme)
[Mozilla](https://developer.mozilla.org/en-US/docs/web/http/basics_of_http/data_urls#datatextplainbase64sgvsbg8sifdvcmxkiq)

--%--
From: rodarima
Date: Fri, 08 Mar 2024 09:46:16 +0000

Do you have an specific example that doesn't work with master?

Dillo already supports the `data:` URI (since Dillo 0.8.6, from 2006):

- Simple HTML:

![image](https://github.com/dillo-browser/dillo/assets/3866127/44393b5b-65e2-4fa1-a196-795ba7b416fc)


- With base64:

![image](https://github.com/dillo-browser/dillo/assets/3866127/4da007fb-2200-46c7-8648-1ca6e38e2d12)

- Inline in a HTML document:

```html
<p>You should see a red dot below</p>
<img alt=""
     src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg=="
     style="width:10px;height:10px" />
```

![image](https://github.com/dillo-browser/dillo/assets/3866127/b3f09bac-4f86-4210-980f-bb67fa3d84af)


--%--
From: dirwiz
Date: Fri, 08 Mar 2024 10:38:17 +0000

My fault.  I can confirm it does work perfectly!  

My testing involved using an SVG for the data part of an IMG.  This didn't appear in the browser.

Also I wanted to embed downloads using data url's.  HTML5 has a "download" attribute for href where you can specify the filename for download when you click on the link.  
Many thanks for the fast response!




--%--
From: rodarima
Date: Fri, 08 Mar 2024 11:20:01 +0000

> My testing involved using an SVG for the data part of an IMG. This didn't appear in the browser.

Yeah, SVG images are not supported yet, but they [are planned](https://github.com/dillo-browser/dillo/issues/70).

> Also I wanted to embed downloads using data url's. HTML5 has a "download" attribute for href where you can specify the filename for download when you click on the link.

Then I will reuse this issue to request this feature (rather than opening a new one).