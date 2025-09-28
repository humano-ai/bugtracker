Title: Ignore meta refresh content without URL
Author: rodarima
Created: Mon, 24 Jun 2024 12:35:20 +0000
State: closed

The content="0" attribute was wrongly parsed as the URL "0". The change makes the parser ignore a redirect with a content value that doesn't have ";" or "url=" after the delay number.

Fixes: https://github.com/dillo-browser/dillo/issues/204