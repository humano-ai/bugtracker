Title: Consider porting devdocs to markdown
Author: rodarima
Created: Mon, 18 Dec 2023 22:19:31 +0000
State: closed

The *devdocs* provide very detailed explanations of algorithms, design ideas and other topics and should be easily reachable. They are currently written in Doxygen .doc format, which is nice to link with the API-like documentation but they require a place to live compiled in HTML (or other formats). They cannot be easily read as-is.

On the other hand, GitHub can render Markdown including Math directly from the repository. This increases quite a lot the accessibility from others to the detailed explanations without leaving the repository.

I did some tests with *dw-line-breaking.doc* and they seem to render quite nicely:

![image](https://github.com/rodarima/dillo/assets/3866127/87a2ed49-2303-4cad-9749-f8651b492408)

The blame is also not very much affected:

![image](https://github.com/rodarima/dillo/assets/3866127/8404031d-f5e2-451b-89df-050d6aa44811)

Which preserves the original authors.

Here is the [permalink](https://github.com/rodarima/dillo/blob/a60881f18a291c31ffc68e46901ad32bfce42268/devdoc/dw-line-breaking.md)

--%--
From: rodarima
Date: Mon, 18 Dec 2023 23:17:08 +0000

However, this makes the devdocs unable to be opened in dillo itself, which would be quite sad. Here is the same document rendered in dillo using Doxygen (take a closer look at the 77 HTML errors in the bottom right):

![dillo-devdoc](https://github.com/dillo-browser/dillo/assets/3866127/39738da6-e65e-4811-a81a-4a4b6e9bb174)


--%--
From: rodarima
Date: Sat, 09 Mar 2024 18:54:38 +0000

For now this is being rendered at https://dillo-browser.github.io/doxygen/index.html from the Doxygen with a new theme. Even if we rewrite the standalone pages in Markdown, there is still a lot of information attached to the source code classes and namespaces that is better represented as-is. It also includes cross references which Doxygen handles gracefully. 

Here are some examples:
- https://dillo-browser.github.io/doxygen/classdw_1_1Image.html#details
- https://dillo-browser.github.io/doxygen/classdw_1_1Table.html#details
- https://dillo-browser.github.io/doxygen/namespacedw_1_1core_1_1style.html#a65610d57c89e5bee02e4e539fdc989de

Apart from that, Doxygen also allows pages to be written in Markdown, including from the source code itself.

The math formulas are currently rendered as images by LaTeX, but Doxygen also allows the usage of MathJax, which renders them in the browser with Javascript. Here is an example with `USE_MATHJAX = YES`:

![image](https://github.com/dillo-browser/dillo/assets/3866127/e104064b-b393-42bb-a404-6130645ad2ee)

Which is very similar to the quality of GitHub and Markdown.

However, the reason they are not shown very well is that the size of the images is too small, so it may be doable to fix it in Doxygen.

For now there is no need to switch to Markdown or other formats, so I'll close this.

