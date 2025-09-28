Title: Missing entity expansion inside PRE
Author: rodarima
Created: Sun, 11 Aug 2024 12:48:34 +0000
State: closed

From https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html

The `<pre>` content is rendered:

    .SUFFIXES: .o .c .y .l .a .sh .f .c&#152; .y&#152; .l&#152; .sh&#152; .f&#152;

While the `&#152;` entity must be rendered as `~`, even inside a `pre` block.

Source: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/pre

> If you have to display reserved characters such as <, >, &, and " within the
> `<pre>` tag, the characters must be escaped using their respective character
> references.
> 
> `<pre>` elements commonly contain `<code>`, `<samp>`, and `<kbd>` elements, to
> represent computer code, computer output, and user input, respectively.


--%--
From: rodarima
Date: Sun, 11 Aug 2024 14:23:32 +0000

Dillo reports:

> HTML warning: line 11, Numeric character reference `'&#152;'` is not valid.

Which is handled by `Html_parse_numeric_charref()`:

```c
if ((codepoint < 0x20 && codepoint != '\t' && codepoint != '\n' &&
     codepoint != '\f') ||
    (codepoint >= 0x7f && codepoint <= 0x9f) ||
    (codepoint >= 0xd800 && codepoint <= 0xdfff) || codepoint > 0x10ffff ||
    ((codepoint & 0xfffe) == 0xfffe) ||
    (!(html->DocType == DT_HTML && html->DocTypeVersion >= 5.0f) &&
     codepoint > 0xffff)) {
   /* this catches null bytes, errors, codes out of range, disallowed
    * control chars, permanently undefined chars, and surrogates.
    */
   char c = *s;
   *s = '\0';
   BUG_MSG("Numeric character reference '&#%s' is not valid.", tok);
   *s = c;

   codepoint = (codepoint >= 145 && codepoint <= 151) ?
               Html_ms_stupid_quotes_2ucs(codepoint) : -1;
}
```

However the tilde character seems to have the Unicode value U+007e or 126 in
decimal.

>>> hex(ord('~'))
'0x7e

Which matches the [ISO-8859-1 character set](https://en.wikipedia.org/wiki/ISO/IEC_8859-1)

From the Wikipedia:

> The popular Windows-1252 character set adds all the missing characters
> provided by ISO/IEC 8859-15, plus a number of typographic symbols, by
> replacing the rarely used C1 controls in the range 128 to 159 (hex 80 to 9F).
> It is very common to mislabel Windows-1252 text as being in ISO-8859-1. A
> common result was that all the quotes and apostrophes (produced by "smart
> quotes" in word-processing software) were replaced with question marks or
> boxes on non-Windows operating systems, making text difficult to read. Many
> Web browsers and e-mail clients will interpret ISO-8859-1 control codes as
> Windows-1252 characters, and that behavior was later standardized in
> HTML5.[20]


In the [Windows-1252](https://en.wikipedia.org/wiki/Windows-1252) table I can
see that the symbol is not the common tilde `~` but a "small tilde" U+02DC `˜`.

So, this seems to be one of those cases where the charset is wrongly set to
ISO-8859-1 instead of Windows-1252. The document content type seems to be wrong:

```html
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
```

Also, the based on the [HTML 4.01
spec](https://www.w3.org/TR/html4/charset.html), the numeric entities must refer
to the "document character set":

> Occasional characters that fall outside this encoding may still be represented
> by character references. These always refer to the document character set, not
> the character encoding.

And the character set is *not* the `charset`, but Unicode:

> The ASCII character set is not sufficient for a global information system such
> as the Web, so HTML uses the much more complete character set called the
> Universal Character Set (UCS), defined in [ISO10646]. This standard defines a
> repertoire of thousands of characters used by communities all over the world.

So the entity `&#152;` is pointing to the [Unicode symbol for "Start Of
String"](https://www.codetable.net/decimal/152), which is non printable.

Therefore, there is no bug on Dillo side, but two bugs on the POSIX manual
page.

- The entity for small tilde must be `&#x02DC;` or `&#732;`
- They probably mean ~ not the small tilde.
