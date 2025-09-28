Title: Segfault when loading https://github.com/dillo-browser/dillo/
Author: rodarima
Created: Sun, 09 Jun 2024 11:00:26 +0000
State: closed

The function a_Url_new() can return NULL if the url is not parsed correctly, but is not being handled properly:
```
[Thread 0x7ffff60006c0 (LWP 2813416) exited]

Thread 1 "dillo" received signal SIGSEGV, Segmentation fault.
0x00005555555c3f3d in a_Html_url_new (html=0x555555a4d980, url_str=0x555555af2c60 "", base_url=0x0, use_base_url=0) at ../../src/html.cc:180
180	   if ((n_ic = URL_ILLEGAL_CHARS(url)) != 0) {
(gdb) bt
#0  0x00005555555c3f3d in a_Html_url_new (html=0x555555a4d980, url_str=0x555555af2c60 "", base_url=0x0, use_base_url=0) at ../../src/html.cc:180
#1  0x00005555555d146c in Html_tag_open_form (html=0x555555a4d980,
    tag=0x555555c152ae "<form id=\"query-builder-test-form\" action=\"\" accept-charset=\"UTF-8\" method=\"get\">\n  <query-builder data-target=\"qbsearch-input.queryBuilder\" id=\"query-builder-query-builder-test\" data-filter-key=\":\" d"..., tagsize=81) at ../../src/form.cc:364
#2  0x00005555555ceb16 in Html_process_tag (html=0x555555a4d980,
    tag=0x555555c152ae "<form id=\"query-builder-test-form\" action=\"\" accept-charset=\"UTF-8\" method=\"get\">\n  <query-builder data-target=\"qbsearch-input.queryBuilder\" id=\"query-builder-query-builder-test\" data-filter-key=\":\" d"..., tagsize=81) at ../../src/html.cc:4053
#3  0x00005555555cfbe9 in Html_write_raw (html=0x555555a4d980,
    buf=0x555555c0da8b "<path d=\"M1.75 1h12.5c.966 0 1.75.784 1.75 1.75v9.5A1.75 1.75 0 0 1 14.25 14H8.061l-2.574 2.573A1.458 1.458 0 0 1 3 15.543V14H1.75A1.75 1.75 0 0 1 0 12.25v-9.5C0 1.784.784 1 1.75 1ZM1.5 2.75v9.5c0 .13"..., bufsize=64188, Eof=0) at ../../src/html.cc:4383
#4  0x00005555555c526d in DilloHtml::write (this=0x555555a4d980,
    Buf=0x555555c04d70 "\n\n\n\n\n\n\n<!DOCTYPE html>\n<html\n  lang=\"en\"\n  \n  data-color-mode=\"auto\" data-light-theme=\"light\" data-dark-theme=\"dark\"\n  data-a11y-animated-images=\"system\" data-a11y-link-underlines=\"true\"\n  >\n\n\n  <head"..., BufSize=100311, Eof=0) at ../../src/html.cc:587
```

--%--
From: rodarima
Date: Sun, 09 Jun 2024 11:40:01 +0000

The fact I introduced this bug shows that the current tests are lacking a lot of cases. Maybe we can add a list of sites to test so we can check that Dillo can parse those sites without a segfault.