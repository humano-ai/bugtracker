function escape(t) {
	# Must do this one first
	gsub(/&/, "\\&amp;", t);
	gsub(/"/, "\\&quot;", t)
	gsub(/</, "\\&lt;", t);
	gsub(/>/, "\\&gt;", t);
	return t;
}

BEGIN { FS=": "; c=0 }

c == 0 && /^Title: /   { sub("Title: ", "");   title=$0 }
c == 0 && /^Author: /  { sub("Author: ", "");  author=$0 }
c == 0 && /^Assignee: / { sub("Assignee: ", ""); assignee=$0 }
c == 0 && /^Created: / { sub("Created: ", ""); date=$0 }
c == 0 && /^State: /   { sub("State: ", "");   state=$0 }
c == 0 && /^Project: / { sub("Project: ", ""); project=$0 }
#/^--%--$/  { c++ }
/^--%--$/  { exit }
END {
	if ((s == "" || state == s) && (p == "" || project == p) && (a == "" || assignee == a)) {
		printf "<tr data-project='%s'>\n", escape(project)
		printf "  <td><a href='%d/'>#%d</a></td>\n", n, n
		printf "  <td class='title-cell' tabindex='0' title='%s' aria-label='%s'>%s</td>\n", escape(title), escape(title), escape(title)
		proj_href = project ".html"
		if (a != "") {
			proj_href = "assignee-" a "-" project ".html"
		}
		printf "  <td class='proj-cell'><a class='proj-chip project-%s' href='%s'>%s</a></td>\n", escape(project), escape(proj_href), escape(project)
		#printf "  <td>%d</td>\n", c
		printf "  <td style='white-space: nowrap'>%s</td>\n", modif
		printf "  <td><span class='issue-state state-%s'>%s</span></td>\n", state, state
		printf "</tr>\n"
		printf "\n"
	}
	exit
}
