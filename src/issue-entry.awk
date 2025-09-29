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
c == 0 && /^Created: / { sub("Created: ", ""); date=$0 }
c == 0 && /^State: /   { sub("State: ", "");   state=$0 }
#/^--%--$/  { c++ }
/^--%--$/  { exit }
END {
	if (s == "" || state == s) {
		printf "<tr>\n"
		printf "  <td><a href='%d/'>#%d</a></td>\n", n, n
		printf "  <td>%s</td>\n", escape(title)
		#printf "  <td>%d</td>\n", c
		printf "  <td style='white-space: nowrap'>%s</td>\n", modif
		printf "  <td><span class='issue-state state-%s'>%s</span></td>\n", state, state
		printf "</tr>\n"
		printf "\n"
	}
	exit
}
