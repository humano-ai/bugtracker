Title: Support for Content-Disposition filename
Author: campaul
Created: Sun, 23 Mar 2025 20:39:56 +0000
State: closed

This is a partial implementation for #168. Currently it only supports the ascii encoded `filename` field and not the more general `filename*` field. This also adds support for the `attachment` content disposition triggering a download even if the content type is able to be displayed.

The `a_Misc_parse_content_disposition` function is modeled after the `a_Misc_parse_content_type` function so a large portion of that function is copy/pasted.


--%--
From: campaul
Date: Thu, 27 Mar 2025 14:54:21 +0000

Spaces in quoted string should work correctly now.

For handling special filesystem characters I added the following behavior which mostly matches what firefox does:
1. Strip all leading periods
2. Replace `/`, `\`, and `|` with `_`
3. Allow `~` because it has no special meaning after 1 and 2 are done


I'm going to continue going through all of the test cases from http://test.greenbytes.de/tech/tc2231/#attabspath over the next few days to make sure there aren't any other edge cases I've missed.

--%--
From: campaul
Date: Fri, 28 Mar 2025 16:40:32 +0000

I've finished checking all the tests from http://test.greenbytes.de/tech/tc2231/#attabspath and the failures are listed below. Most of the failures are consistent with Firefox's behavior so I'm not sure if we should fix them to match the tests or just leave them as is. Please let me know how you'd like me to handle those.

The tests for `filename*`, `creation-date`, and `modification-date` are omitted since those fields are currently ignored.

### Failures that I'm working on fixing
- Escaped quotes handled incorrectly
`attachment; filename="\"quoting\" tested.html"` becomes `_"quoting_" tested.html` instead of `"quoting" tested.html`
- Unknown content dispositions are treated as inline, should be treated as attachment
- "=" is allowed in token field
`attachment; filename==?ISO-8859-1?Q?foo-=E4.html?=` should fail to parse but works as though it was quoted

### Failures that are consistent with Firefox's behavior
**Should be parse errors but still parses filename (picks same name as Firefox)**
- attachment; filename=foo,bar.html
- attachment; filename=foo.html ;
- attachment; filename="foo.html"; filename="bar.html"
- attachment; filename=foo[1]\(2\).html
- attachment; inline; filename=foo.html
- attachment; filename="foo.html".txt
- attachment filename=bar

**Should be parse errors but still parses filename (picks different name than Firefox)**
- attachment; ;filename=foo
- attachment; filename=foo bar.html
- attachment; filename="bar
- attachment; filename=foo"bar;baz"qux
- attachment; filename=foo.html, attachment; filename=bar.html
- attachment; foo=foo filename=bar
- attachment; filename=bar foo=foo 

**Serves as inline when it should download**
- attachment; filename="foo-ä.html"
- attachment; filename="foo-Ã¤.html"
- attachment; filename="ä-%41.html"


--%--
From: rodarima
Date: Fri, 28 Mar 2025 18:59:20 +0000

> Spaces in quoted string should work correctly now.

Thanks!

> Allow ~ because it has no special meaning after 1 and 2 are done

I'll would also replace it either entirely or from the start, as `~user` could still be expanded to the home directory of `user`.

> I've finished checking all the tests from http://test.greenbytes.de/tech/tc2231/#attabspath and the failures are listed below. Most of the failures are consistent with Firefox's behavior so I'm not sure if we should fix them to match the tests or just leave them as is. Please let me know how you'd like me to handle those.

I'm okay with being more or less consistent with Firefox, long as there are no cases that cause a crash or an expected attachment document is shown as inline.

Also, I believe we should leave the (uchar_t) cast as it was, as it can cause values above 127 to be considered negative and extend the sign into a int, causing a value that is out of range for unsigned char. Some of those unusual symbols may be wrongly expanded and fail to pass some of the isascii()-family tests.

I'll leave you here a patch to add a unit test to check multiple content dispositions (you can add get the commit with `git am < disp.patch`). I added some example cases myself, but we can add the ones from that page which would speed up testing. Check with `make check TESTS=disposition VERBOSE=1`:

```diff
From 00d2ce3d8935095a4064b84c24225cd20a113aad Mon Sep 17 00:00:00 2001
From: Rodrigo Arias Mallo <rodarima@gmail.com>
Date: Fri, 28 Mar 2025 19:32:28 +0100
Subject: [PATCH] Add content disposition unit test

---
 test/unit/Makefile.am   |  6 +++
 test/unit/disposition.c | 88 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+)
 create mode 100644 test/unit/disposition.c

diff --git a/test/unit/Makefile.am b/test/unit/Makefile.am
index bcf3e3cb..b372a1ae 100644
--- a/test/unit/Makefile.am
+++ b/test/unit/Makefile.am
@@ -11,6 +11,7 @@ LDADD = \
 
 TESTS = \
 	containers \
+	disposition \
 	identity \
 	liang \
 	notsosimplevector \
@@ -30,6 +31,11 @@ containers_SOURCES = containers.cc
 containers_LDADD = \
 	$(top_builddir)/lout/liblout.a \
 	$(top_builddir)/dlib/libDlib.a
+disposition_SOURCES = \
+	$(top_srcdir)/src/misc.c \
+	disposition.c
+disposition_LDADD = \
+	$(top_builddir)/dlib/libDlib.a
 notsosimplevector_SOURCES = notsosimplevector.cc
 identity_SOURCES = identity.cc
 identity_LDADD = \
diff --git a/test/unit/disposition.c b/test/unit/disposition.c
new file mode 100644
index 00000000..a2f5fc46
--- /dev/null
+++ b/test/unit/disposition.c
@@ -0,0 +1,88 @@
+/*
+ * File: disposition.c
+ *
+ * Copyright 2025 Rodrigo Arias Mallo <rodarima@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "dlib/dlib.h"
+#include "src/misc.h"
+
+#include <stdlib.h>
+
+struct testcase {
+   const char *disposition;
+   const char *type;
+   const char *filename;
+};
+
+struct testcase cases[] = {
+   /* See http://test.greenbytes.de/tech/tc2231/ */
+   { "attachment; filename=\"\\\"quoting\\\" tested.html\"", "attachment", "_\"quoting_\" tested.html" },
+   //{ "attachment; filename=\"\\\"quoting\\\" tested.html\"", "attachment", "quoting" }, /* <-- Should be this */
+   { "attachment; filename=\"/foo.html\"", "attachment", "_foo.html" },
+   { "attachment; filename=/foo", "attachment", "_foo" },
+   { "attachment; filename=./../foo", "attachment", "_.._foo" },
+   { "attachment; filename=", "attachment", NULL },
+   { "attachment; filename= ", "attachment", NULL },
+   { "attachment; filename=\"", "attachment", NULL },
+   { "attachment; filename=\"foo", "attachment", NULL },
+   { "attachment; filename=~/foo", "attachment", "~_foo" },
+};
+
+static int equal(const char *a, const char *b)
+{
+   if (a == NULL && b == NULL)
+      return 1;
+
+   if (a == NULL || b == NULL)
+      return 0;
+
+   return strcmp(a, b) == 0;
+}
+
+int main(void)
+{
+   char dummy[] = "dummy";
+   int ncases = sizeof(cases) / sizeof(cases[0]);
+   int rc = 0;
+
+   for (int i = 0; i < ncases; i++) {
+      struct testcase *t = &cases[i];
+      char *type = dummy;
+      char *filename = dummy;
+      a_Misc_parse_content_disposition(t->disposition, &type, &filename);
+      if (!equal(type, t->type)) {
+         fprintf(stderr, "test %d failed, type mismatch:\n", i);
+         fprintf(stderr, "  Content-Dispsition: %s\n", t->disposition);
+         fprintf(stderr, "  Expected type: %s\n", t->type);
+         fprintf(stderr, "  Computed type: %s\n", type);
+         rc = 1;
+      }
+
+      if (!equal(filename, t->filename)) {
+         fprintf(stderr, "test %d failed, filename mismatch:\n", i);
+         fprintf(stderr, "  Content-Dispsition: %s\n", t->disposition);
+         fprintf(stderr, "  Expected filename: %s\n", t->filename);
+         fprintf(stderr, "  Computed filename: %s\n", filename);
+         rc = 1;
+      }
+
+      dFree(type);
+      dFree(filename);
+   }
+
+   return rc;
+}
-- 
2.48.1

```


--%--
From: campaul
Date: Fri, 28 Mar 2025 20:15:27 +0000

Thanks for that patch, that's a really good starting point for me to write more tests. Unfortunately I'm getting a linker error when I try to run the test. It looks like the same error is showing up in CI at https://github.com/dillo-browser/dillo/actions/runs/14137052775/job/39611193831?pr=373, any idea what might be wrong?

--%--
From: rodarima
Date: Fri, 28 Mar 2025 20:50:51 +0000

> Thanks for that patch, that's a really good starting point for me to write more tests. Unfortunately I'm getting a linker error when I try to run the test. It looks like the same error is showing up in CI at https://github.com/dillo-browser/dillo/actions/runs/14137052775/job/39611193831?pr=373, any idea what might be wrong?

Hmm, it was working for me with gcc 14.2.1, and it seems to work on macos too. We are building that test without including all the dependencies for all functions in misc.o, but for that particular content disposition function, we include all that is neccessary. I suspect on older gccs it complains if it cannot find all symbol definitions.

One quick workaround is to move the function as an static inline in the misc.h header and drop the misc.o requirement from the Makefile.am. I can take a look later to try to fix it properly. We need to split a lot of objects from the dillo binary into a single static library to be able to link it with unit tests. I already had a WIP patch, maybe this is a good time to finish it.

*Edit*: Is the `-flto=auto` flag that makes it work. We shouldn't rely on that.

--%--
From: campaul
Date: Sat, 29 Mar 2025 00:23:59 +0000

I set `-flto=auto` for the moment so the tests can run. I also decided to replace all `~` with `_` to be on the safe side.

I have added all the relevant tests from the list to the unit test file and updated the parser until they all passed.

The only remaining issue I have on my list is treating unknown content dispositions the same as `attachment`.

Edit: also put back the `uchar_t` casts.

--%--
From: rodarima
Date: Fri, 04 Apr 2025 23:19:01 +0000

> I set `-flto=auto` for the moment so the tests can run. I also decided to replace all `~` with `_` to be on the safe side.
> 
> I have added all the relevant tests from the list to the unit test file and updated the parser until they all passed.
> 
> The only remaining issue I have on my list is treating unknown content dispositions the same as `attachment`.
> 
> Edit: also put back the `uchar_t` casts.

Thanks a lot for the effort, it is looking nice. I think we can leave as-is for now, I will do a more through review on the parser when I have a moment.

I've been trying to split the code into an static libraries so we can link the unit test cases against to, but it would require much more effort than what I had imagined. There is a lot of coupling among modules, so it will be a pain. I will need to split them slowly.

For this particular case, I would be inclined to move the function into the header and make it a static inline, AFAIK it only depends on dlib. I will try to do this myself to fix the pipeline and prepare this for merging.

--%--
From: rodarima
Date: Wed, 30 Apr 2025 22:53:31 +0000

Sorry for the long delay, it took me a while to review the algorithms in detail.

I have flattened the control flow so it doesn't nest conditionals. I have also tried to simplify the two last loops in less clever algorithms. It is a bit slower, but I believe it is less error prone an easier to read. I have also rebased it with the latest commit.

There were also a couple of potential memory leaks which are fixed now. All tests are passing, and also added a few more cases.

Let me know what you think.

--%--
From: campaul
Date: Thu, 01 May 2025 14:46:28 +0000

That all looks great to me. I think this is ready to merge if you don't have any further issues.