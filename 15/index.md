Title: Add a test infrastructure
Author: rodarima
Created: Sun, 17 Dec 2023 19:22:59 +0000
State: closed

There are no automatic tests. We have some small tests in `test/` but we should be adding much more to cover the HTML and CSS specs.

Additionally, we should have some way to automate some clicks to avoid human intervention in tests. For example, in #14 we cannot test it in CI as of now, as we would need to open a duckduckgo search test, then click in one of the links and then ensure that a non-broken page is loaded.

--%--
From: rodarima
Date: Wed, 20 Dec 2023 19:29:30 +0000

Using Xvfb to create a virtual Xorg framebuffer, we can run dillo in the GitHub CI. We can also take screenshots of the window and compare them to reference ones. Here is an example:

Launch a virtual display at :33
```
$ Xvfb :33 -screen 5 1024x768x8 &
```
Run dillo in that display:
```
$ DISPLAY=:33 dillo google.es
```
Take screenshot of the whole screen:
```
$ DISPLAY=:33 xwd -root -silent | convert xwd:- png:screenshot.png
```
Or if the window id is specified to take only Dillo window:
```
DISPLAY=:33 xwd -id 0x200009 -silent | convert xwd:- png:screenshot.png
```

And here is the result:
<img src="https://github.com/dillo-browser/dillo/assets/3866127/3114fb12-45f1-46f8-b519-2d9767f9b683" width="60%" />

However, we still need to prepare most of the tests to use automatic feedback, as they are mostly designed to be run by a human.

--%--
From: rodarima
Date: Wed, 20 Dec 2023 20:46:41 +0000

I'll first focus on unit tests and defer the automatization of more complex tests for another MR. Most unit tests also lack automatic checks, example:

```c
void testHashTable ()
{
   puts ("--- testHashTable ---");

   HashTable<String, Integer> h(true, true);

   h.put (new String ("one"), new Integer (1));
   h.put (new String ("two"), new Integer (2));
   h.put (new String ("three"), new Integer (3));

   puts (h.toString());

   h.put (new String ("one"), new Integer (4));
   h.put (new String ("two"), new Integer (5));
   h.put (new String ("three"), new Integer (6));

   puts (h.toString());
}

``` 

--%--
From: rodarima
Date: Thu, 28 Dec 2023 00:28:34 +0000

In order to test several properties of HTML and CSS layout, we can make a reference test, in which the feature to test is not used. Then, we generate a screenshot of both renders and compare them to be exactly the same.

--%--
From: rodarima
Date: Sat, 30 Dec 2023 18:10:56 +0000

One of the current problems with the `make check` target is that it should work before `make install`. However, dillo would need a working dpi directory in order to run the tests, so we can use the file plugin. Currently, the test pages are failing to render because dillo cannot start the file plugin to access the local pages.