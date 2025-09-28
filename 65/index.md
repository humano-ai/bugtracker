Title: Rewrite HTML plugin design
Author: rodarima
Created: Sun, 21 Jan 2024 12:16:30 +0000
State: open

Users should have the ability to modify pages on their own, *easily* and by using their preferred language. They should be able to place rules so that pages matching the rules perform some changes and others don't.

Here are some examples that could use such feature:

- Some pages are really broken when no JS is available, but they could be fixed if we could rewrite some parts. This is generally page specific.
- Generate a table of contents and place it in the top of the page.
- Read `<link>` tags for alternate pages and display them (RSS).

Ideally, we would like to have a design such that it has the following features:

- Low performance cost
- Stream mode, where the page is loading but we begin the transformation and pass the data to the next stage without delays
- Allow rewrite plugins to be chained together

For this to happen, we would need to make a decision about how the data is sent from the website to the plugins. We have some options, which are not mutually exclusive.

## Raw HTML

Just send the page as-is to the plugin stdin and then read the stdout to get the transformed HTML. This is the simplest design, but has the drawback that we would (likely) need to implement a HTML parser in each plugin and parse the page again in each transformation.

## Intermediate language

Instead of using HTML, we could transform it to something intermediate that is easier to parse in such a way that the plugins can simply disregard all the content they are not interested in and then just apply match rules that only require a minimal amount of processing. A simple language should allow users to write simple sed or awk plugins to perform simple tasks, without requiring to parse of the whole document tree. This would reduce the amount of processing for plugins, but it would require learning a new language which may be costly. 

## Document tree in memory

Another option is to allow plugins to read and modify the document tree in memory. As we will be processing the HTML in stream mode, we cannot wait until the whole tree is created and the post-process it. It must be updated in iterations where new content is added to the tree and this new content can be send to plugins for processing. The plugins could hook into some elements or rules so only that content is sent to them.

This is probably the most efficient way to do it, but it would restrict writting the plugins in a way that is compatible with the document tree API, and that would also restrict the languages. Furthermore, as we change the API the plugins will become outdated, so this is not such a great idea.

## Use JavaScript 

Finally, the option that I would hate the most, is to implement something similar (or just the same) as JavaScript, where the plugins are written in a language that can be executed by the browser to manipulate the document tree. This would hide internal changes in the API and allow writting simpler programs. However, this would only allow plugins to be written in JS, and the emulation of the language would introduce more performance cost.

This option may also not be suitable for the stream mode, where the document tree is still loading, and may cause cascade effects when two plugins are hooked in the same change events. In any case, this would require us to implement support for JavaScript, which would not be an easy task.

---

To determine which option or options to implement, a simple plan is to just try to code some plugins as a proof of concept and see how they behave. Then, we would have real data on how the performance is affected, instead of just performing some premature optimization.

See also #56 

--%--
From: rodarima
Date: Sun, 21 Jan 2024 13:03:37 +0000

Here is an example of how a intermediate language for HTML bassed on troff could be used by standard text processing utils like AWK:

```groff
% cat test.mm
.tb html
.tb head
.tb link
.ta rel "alternate"
.ta type "application/rss+xml"
.ta href "/feed.xml"
.te link
.tb link
.ta rel "alternate"
.ta type "application/atom+xml"
.ta href "/atom.xml"
.te link
.te head
.tb body
.tb p
Hello from the body
.te p
.te body
.te html
```
Where commands begin with a dot in the first character. Commands are `tb` for begin tag, `te` for end tag and `ta` for tag attribute.

And here is the AWK program that injects the links after the body:
```awk
% cat parse.awk
BEGIN			{ n=0 }
/^\.tb head/		{ inhead=1 }
/^\.tb link/ && inhead	{ inlink=1; href=""; type="" }
/^\.ta type/ && inlink	{ type=$3 } # FIXME: Handle spaces
/^\.ta href/ && inlink	{ href=$3 }
/^\.te link/ && inlink \
	&& href != "" \
	&& type != ""	{ hrefs[n]=href; types[n]=type; n++; inlink=0 }

{ print } # Print the page as is by default

/^.tb body/ && n > 0 {
	print ".tb div"
	print ".ta class dillo-plugin-rss"
	for (i = 0; i < n; i++) {
		print ".tb p"
		printf "Feed with type %s at %s\n", types[i], hrefs[i]
		print ".te p"
	}
	print ".te div"
}
```
After running it:
```diff
% awk -f parse.awk < test.mm > test.pp
% diff -up test.mm test.pp
--- test.mm	2024-01-21 13:48:35.493905662 +0100
+++ test.pp	2024-01-21 13:56:26.554871231 +0100
@@ -12,6 +12,15 @@
 .te link
 .te head
 .tb body
+.tb div
+.ta class dillo-plugin-rss
+.tb p
+Feed with type "application/rss+xml" at "/feed.xml"
+.te p
+.tb p
+Feed with type "application/atom+xml" at "/atom.xml"
+.te p
+.te div
 .tb p
 Hello from the body
 .te p
```

--%--
From: rodarima
Date: Sun, 21 Jan 2024 15:34:20 +0000

Here is a rewrite of the previous plugin in C, showing how we can partially parse a pseudo-HTML document:

```c
#include <stdio.h>
#include <string.h>

#define MAXLINKS 32
#define MAXLINE 4096

struct link {
	char *href;
	char *type;
};

struct state {
	int nlinks;
	struct link links[MAXLINKS];

	int in_head;
	int in_link;
	int in_body;
	int emitted;
};

void parsebegin(struct state *st, char *token)
{
	if (strncmp(token, "head", 4) == 0) {
		st->in_head = 1;
	} else if (st->in_head && strncmp(token, "link", 4) == 0) {
		st->in_link = 1;
	} else if (strncmp(token, "body", 4) == 0) {
		st->in_body = 1;
	}
}

char *cleanstr(char *str)
{
	int n = strlen(str);
	if (str[n-1] == '\n')
		str[n-1] = '\0';

	return str;
}

void parseattr(struct state *st, char *token)
{
	if (!st->in_link)
		return;

	struct link *link = &st->links[st->nlinks];

	if (strncmp(token, "type", 4) == 0) {
		link->type = cleanstr(strdup(token + 5));
	} else if (strncmp(token, "href", 4) == 0) {
		link->href = cleanstr(strdup(token + 5));
	}
}

void parseend(struct state *st, char *token)
{
	struct link *link = &st->links[st->nlinks];

	if (st->in_head && strncmp(token, "head", 4) == 0) {
		st->in_head = 0;
	} else if (st->in_body && strncmp(token, "body", 4) == 0) {
		st->in_body = 0;
	} else if (st->in_link && strncmp(token, "link", 4) == 0) {
		st->in_link = 0;

		/* Accept */
		if (link->href && link->type)
			st->nlinks++;
	}
}

void parseline(struct state *st, char *line)
{
	if (st->nlinks >= MAXLINKS)
		return;

	int n = strlen(line);
	if (n < 4)
		return;

	int a = line[0], b = line[1], c = line[2], d = line[3];

	if (a != '.' || d != ' ')
		return;

	if (b != 't')
		return;

	char *next = line + 4;
	if (c == 'b')
		parsebegin(st, next);
	else if (c == 'a')
		parseattr(st, next);
	else if (c == 'e')
		parseend(st, next);
}

void post(struct state *st)
{
	if (!st->in_body || st->emitted)
		return;

	printf(".tb div\n");
	printf(".ta class dillo-plugin-rss\n");
	for (int i = 0; i < st->nlinks; i++) {
		struct link *link = &st->links[i];
		printf(".tb p\n");
		printf("Feed with type %s at %s\n", link->type, link->href);
		printf(".te p\n");
	}
	printf(".te div\n");

	st->emitted = 1;
}

int main()
{
	char line[MAXLINE];
	struct state st = { 0 };

	while (fgets(line, MAXLINE, stdin)) {
		parseline(&st, line);

		fprintf(stdout, "%s", line);

		post(&st);
	}

	return 0;
}

```

And here is the comparison with perf:

```
% perf stat awk -f parse.awk < test.mm > /dev/null

 Performance counter stats for 'awk -f parse.awk':

              5,58 msec task-clock:u                     #    0,816 CPUs utilized
                 0      context-switches:u               #    0,000 /sec
                 0      cpu-migrations:u                 #    0,000 /sec
               268      page-faults:u                    #   48,010 K/sec
         6.409.278      cycles:u                         #    1,148 GHz
        10.779.901      instructions:u                   #    1,68  insn per cycle
         2.305.817      branches:u                       #  413,064 M/sec
            68.228      branch-misses:u                  #    2,96% of all branches

       0,006839612 seconds time elapsed

       0,006870000 seconds user
       0,000000000 seconds sys


% perf stat ./parse < test.mm > /dev/null

 Performance counter stats for './parse':

              1,27 msec task-clock:u                     #    0,492 CPUs utilized
                 0      context-switches:u               #    0,000 /sec
                 0      cpu-migrations:u                 #    0,000 /sec
                61      page-faults:u                    #   47,852 K/sec
           241.231      cycles:u                         #    0,189 GHz
           165.656      instructions:u                   #    0,69  insn per cycle
            37.918      branches:u                       #   29,745 M/sec
             2.722      branch-misses:u                  #    7,18% of all branches

       0,002591042 seconds time elapsed

       0,000000000 seconds user
       0,002544000 seconds sys

```

I uses 65 times less instructions (but is not 65 times faster).

--%--
From: rodarima
Date: Sun, 21 Jan 2024 17:13:57 +0000

CloudFlare has done some work in this area to rewrite parts of the websites they intercept using [a stream parser](https://github.com/cloudflare/lazyhtml). They have [a blog post](https://blog.cloudflare.com/html-parsing-1) where they explain some details.

As far as I understand, this would be an example where we transform the tree in memory, updating it chunk by chunk.

They claim they process a large document (8 MiB) at up to 160 MiB/s, but they don't mention the HW used. Maybe it could serve as a comparison if we manage to do something similar with an intermediate language.

--%--
From: rodarima
Date: Thu, 25 Jan 2024 21:53:27 +0000

If we continue with the intermediate language idea, we should also make it a larger subset that just HTML. For example, it would be nice if we have access to the response HTTP headers too.

This makes me think that plugins may also need to rewrite the requests and not only the response. For example, we may want to redirect petitions *before* they are made, or change HTTP headers.

--%--
From: rodarima
Date: Sat, 27 Jan 2024 12:38:48 +0000

Another problem that we face how to solve transformations that requires double or more passes. An example of this is the table of contents, where we index the secions (h1, h2, ...) and then display a menu in the top of the page with the table of contents.

A way to solve this problem is to allow plugins to work with auxiliary streams and allow adding a reference to inject content from other streams. Example:

```html
<html>
  <body>
    <h1>Main title</h1>
    <p>blah blah</p>
    <h2>Section 1</h2>
    <p>blah blah</p>
    <h2>Section 2</h2>
    <p>blah blah</p>
  </body>
</html>
```

To produce something like this:

```html
<html>
  <body>
    <div class="toc">
      <ul>
        <li>Main title
          <ul>
            <li>Section 1</li>
            <li>Section 2</li>
          </ul>
        </li>
        <li>Another title</li>
    </div>
    <h1>Main title</h1>
    <p>blah blah</p>
    <h2>Section 1</h2>
    <p>blah blah</p>
    <h2>Section 2</h2>
    <p>blah blah</p>
    <h1>Another title</h1>
  </body>
</html>
```

We could inject an element that includes content from another file descriptor. Like this:

```html
<html>
  <body>
    <specialref fd="42"/>
    <h1>Main title</h1>
    <p>blah blah</p>
    <h2>Section 1</h2>
    <p>blah blah</p>
    <h2>Section 2</h2>
    <p>blah blah</p>
    <h1>Another title</h1>
  </body>
</html>
```
And then the plugin would write in another fd the table of content as it is being processed from the main stream. The content is not blocked and can continue to be processed in stream mode. The TOC plugin should also make the headers have a unique id, so we can properly link them.

We could also inject the content after the main stream is processed, but that would require the plugin to store all the intermediate information in memory. The clean solution is allowing multiple streams.