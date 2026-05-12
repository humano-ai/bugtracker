function escape(t) {
	# Must do this one first
	gsub(/&/, "\\&amp;", t);
	gsub(/"/, "\\&quot;", t)
	gsub(/</, "\\&lt;", t);
	gsub(/>/, "\\&gt;", t);
	return t;
}

BEGIN { FS=": "; s=1; c=0 }

s==1 && /^Title: /   { sub("Title: ", "");    title=$0 }
s==1 && /^Author: /  { sub("Author: ", "");   author=$0 }
s==1 && /^Assignee: / { sub("Assignee: ", ""); assignee=$0 }
s==1 && /^Created: / { sub("Created: ", "");  date=$0 }
s==1 && /^State: /   { sub("State: ", "");    state=$0 }
s==1 && /^Project: / { sub("Project: ", "");  project=$0 }
s==1 && $0 == "" {
	printf "<!doctype html>\n"
	printf "<html>\n"
	printf "<head>\n"
	printf "  <meta charset='utf-8' />\n"
	printf "  <title>Humano - %s</title>\n", title
	printf "  <meta name='title' content='Humano - %s' />\n", escape(title)
	printf "  <meta property='og:title' content='Humano - %s' />\n", escape(title)
	printf "  <meta property='og:type' content='website' />\n"
	printf "  <meta property='og:url' content='https://humano-ai.github.io/bugtracker/' />\n"
	printf "  <meta name='twitter:card' content='summary' />\n"
	printf "  <meta name='twitter:title' content='Humano - %s' />\n", escape(title)
	printf "  <base href='/bugtracker/' />\n"
	printf "  <link rel='stylesheet' href='style.css' type='text/css' />\n"
	printf "  <link rel='icon' href='https://e32d51af3de97804b3f8dcfcb7e70a04.cdn.bubble.io/f1714242605974x627282198030633300/humano-fav-icon.png' />\n"
	printf "  <link rel='shortcut icon' href='https://e32d51af3de97804b3f8dcfcb7e70a04.cdn.bubble.io/f1714242605974x627282198030633300/humano-fav-icon.png' />\n"
	printf "</head>\n"
	printf "<body>\n"
	printf "  <table class='issue-meta'>\n"
	printf "    <tr><th>Title</th><td>%s</td></tr>\n", escape(title)
	printf "    <tr><th>Author</th><td>%s</td></tr>\n", author
	if (assignee != "") {
		printf "    <tr><th>Assignee</th><td><img class='avatar' src='https://github.com/%s.png?size=40' alt='%s' title='%s' loading='lazy' /> %s</td></tr>\n", escape(assignee), escape(assignee), escape(assignee), escape(assignee)
	}
	printf "    <tr><th>Created</th><td>%s</td></tr>\n", date
	printf "    <tr><th>State</th>"
	printf "    <td><span class='issue-state state-%s'>%s</span></td>", state, state
	printf "    </tr>\n"
	if (project != "") {
		printf "    <tr><th>Project</th><td><a href='%s.html'>%s</a></td></tr>\n", escape(project), escape(project)
	}
	printf "  </table>\n"
	printf "\n"
	s = 2
	next
}

# Description
s==2 && $0 == "--%--" {
	com_author = ""
	com_date = ""
	s = 3
	c++
	next
}
s==2 { print }

# Comment header
s==3 && /^From: / { sub("From: ", ""); com_author=$0 }
s==3 && /^Date: / { sub("Date: ", ""); com_date=$0 }
s==3 && $0 == "" {
	printf "\n"
	printf "<div id='c%d' class='comment'>\n", c
	printf "  <div class='comment-meta'>\n"
	printf "    <a href='#c%d'>%s</a> on <i>%s</i>\n", c, com_author, com_date
	printf "  </div>\n"
	printf "\n"
	s = 4
	next
}

# Comment body
s==4 && $0 == "--%--" {
	# Close previous comment
	printf "</div>\n\n"
	com_author = ""
	com_date = ""
	s = 3
	c++
	next
}
s==4 { print }

END {
	if (s == 4) {
		printf "</div>\n"
	}
	printf "\n\n"
	printf "<footer><a href='./'>&larr; Index</a></footer>"
	printf "</body>"
	printf "</html>"

#	printf "title=\"%s\"\n", title;
#	printf "author=%s\n", author;
#	printf "author=%s\n", author;
}
