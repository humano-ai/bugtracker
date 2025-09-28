Title: Display more parsing errors and deprecation warnings
Author: rodarima
Created: Sun, 10 Mar 2024 16:21:42 +0000
State: open

We should differentiate between at least the following:
- CSS or HTML parsing errors (typically a mismatch of open and close tags)
- Non implemented features: Things that are not implemented but the page is trying to make use of. For example the `media()` CSS request.
- Deprecation warnings: For example, in an HTML 5 document, using a table with the align attribute.

We may want to display them in a similar way as the "bug meter", so the user can determine if the page that it is seeing it is expected to be properly rendered. Or if the problems found in the page are "minor" and it is expected to be rendered properly anyway.

--%--
From: rodarima
Date: Sat, 06 Jul 2024 10:29:06 +0000

This should also include features that we don't support from SVG images.