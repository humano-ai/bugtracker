Title: Consider switching the CSS parser to flex + bison
Author: rodarima
Created: Sun, 01 Dec 2024 15:56:11 +0000
State: closed

Given that CSS is a context-free grammar, we may be able to switch to flex + bison and create a parser that can easily handle the latest CSS spec. Extending the current parser to add support for variables and functions can be done, but will likely require more effort.

The CSS standard provides some reference grammar that we can use as a starting point, and it would make it much easier to read and be sure we are following the spec correctly.

Notice that a page may cause a DoS by abusing the `calc()` functions. We may want to also consider a CPU budget per page, so we can stop hungry sites from hanging the browser.

We would also need to consider how much the generated parser weights, not to exceed out release tarball size budget, as we are already at 90% of the floppy size. Considering only the `.l` and `.y` sources is not acceptable, as that would add flex and bison as a mandatory build dependency. Preliminary results show at least 50KiB (15KiB compressed) for the scanner and 60KiB+ (17KiB compressed) for the parser.

--%--
From: rodarima
Date: Wed, 04 Dec 2024 18:34:29 +0000

While CSS might be a context-free grammar, it has moved away from being easily described by a flex scanner and bison parser. All major rendering engines have moved to a recursive descend, and the whole specification has also moved to a recursive descend approach.

The current CSS parser in dillo is also a recursive descend parser with "only" 1800 lines (56 KiB). LALR parsers have some benefits over RD, but I don't think they are particularly useful for Dillo.

I think it would be better to wait until we see clear drawbacks with the current parser before we implement a new LALR parser. We can improve the current one first, specially the error reporting which is currently missing.

A very different topic is why the CSS WG had decided to implement a painfully complicated language that cannot be easily scanned by ignoring whitespace.

Closing for now.