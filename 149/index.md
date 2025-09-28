Title: Implement support for CSS variables
Author: rodarima
Created: Fri, 03 May 2024 23:18:41 +0000
State: open

Websites often use variables to store CSS values that have a large impact in how the page is rendered. As we simply ignore all variables, pages don't layout properly even if we support most of the underlying CSS properties.

Example for https://gwern.net/search where most CSS rules use variables:
```CSS
...
body {
    max-width: var(--GW-body-max-width);
    padding: 0 var(--GW-body-side-padding);
    margin: 0 auto;
}
...
```

This is how is rendered in Firefox without JS enabled:

![image](https://github.com/dillo-browser/dillo/assets/3866127/0aafcba6-e6f7-4ffd-8a72-081b71715bd8)

But it looks like this in Dillo:

![d](https://github.com/dillo-browser/dillo/assets/3866127/6a82bd1c-2641-4287-ab34-7e05a5a97f1b)
