Title: Improve quirk for text/xhtml content type
Author: rodarima
Created: Tue, 23 Apr 2024 21:21:35 +0000
State: closed

When a <meta> tag reports the "text/xhtml" content, we were correcting it to the type guessed in TypeDet. However, the current implementation to guess XHTML and HTML pages fails if the doctype is not at the start of the document, falling back to text/plain.

A more robust solution is to set the TypeNorm to "application/xhtml+xml", which can be handled by a_Mime_get_viewer() as an HTML-like document.

Fixes: https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/thread/7GJ4AAMFFPEHOIYEOH4NHVMSXMJDFYXG/