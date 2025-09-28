Title: Missing entities lsquo and rsquo
Author: rodarima
Created: Sat, 02 Nov 2024 09:21:51 +0000
State: closed

Source: https://www.w3.org/2000/04/26-csrules.html

```
1. The hierarchy (<body> / <div1> / <div2> / <p>) is unaffected by whether
forms are present or not; <form> is &lsquo;transparent&rsquo; to the hierarchy.
```

--%--
From: rodarima
Date: Sat, 02 Nov 2024 09:27:26 +0000

Nevermind, it is wrong HTML:

```html
<li> The hierarchy (<tt>&lt;body&gt;</tt> / <tt>&lt;div1&gt;</tt> / <tt>&lt;div2&gt;</tt> /
<tt>&lt;p&gt;</tt>) is unaffected by whether forms are present or not;
<tt>&lt;form&gt;</tt> is &amp;lsquo;transparent&amp;rsquo; to the
hierarchy.</li>
```
We do support lsquo and rsquo.