#!/bin/sh -e

projects=$(for f in $(find . -maxdepth 2 -name index.md -print); do
  awk -v a="$ASSIGNEE_FILTER" '
    /^Project: / { sub("Project: ", ""); project=$0 }
    /^Assignee: / { sub("Assignee: ", ""); assignee=$0 }
    END { if (project != "" && (a == "" || assignee == a)) print project }
  ' "$f"
done | sort -u)
assignees=$(find . -maxdepth 2 -name index.md -print \
  | xargs awk '/^Assignee: / { sub("Assignee: ", ""); print; nextfile }' \
  | sort -u)
if [ -n "$ASSIGNEE_FILTER" ]; then
  assignees="$ASSIGNEE_FILTER"
fi
avatars=$(printf '%s\n' "$assignees" | awk 'NF { printf "<a class=\"avatar-link\" href=\"assignee-%s.html\" title=\"%s\"><img class=\"avatar avatar-large\" src=\"https://github.com/%s.png?size=80\" alt=\"%s\" loading=\"lazy\" /></a>", $0, $0, $0, $0 }')

cat <<EOF
<!doctype html>
<head>
  <meta charset='utf-8' />
  <title>Humano - Cross-Project Ticket Tracker</title>
  <meta name='title' content='Humano - Cross-Project Ticket Tracker' />
  <meta property='og:title' content='Humano - Cross-Project Ticket Tracker' />
  <meta property='og:type' content='website' />
  <meta property='og:url' content='https://humano-ai.github.io/bugtracker/' />
  <meta name='twitter:card' content='summary' />
  <meta name='twitter:title' content='Humano - Cross-Project Ticket Tracker' />
  <base href='/bugtracker/' />
  <link rel='stylesheet' href='style.css' type='text/css' />
  <link rel='icon' href='https://e32d51af3de97804b3f8dcfcb7e70a04.cdn.bubble.io/f1714242605974x627282198030633300/humano-fav-icon.png' />
  <link rel='shortcut icon' href='https://e32d51af3de97804b3f8dcfcb7e70a04.cdn.bubble.io/f1714242605974x627282198030633300/humano-fav-icon.png' />
</head>
<body>
  <p class='filters'><span class='assignee-filter'>Assignee: <span class='avatar-stack'>$avatars</span></span> State: <a href="./">open</a> | <a href="any.html">any</a>$(printf '%s\n' "$projects" | awk -v a="$ASSIGNEE_FILTER" 'NF { if (!done) { printf " &nbsp;Project: "; done=1 } else { printf " | " }; if (a != "") printf "<a href=\"assignee-%s-%s.html\">%s</a>", a, $0, $0; else printf "<a href=\"%s.html\">%s</a>", $0, $0 }')</p>
  <table class='issue-index'>
    <colgroup>
      <col class='c-num' />
      <col class='c-title' />
      <col class='c-proj' />
      <col class='c-date' />
      <col class='c-state' />
    </colgroup>
    <tr>
      <th>Ticket</th>
      <th>Title</th>
      <th>Project</th>
      <th>Updated</th>
      <th>State</th>
    </tr>
EOF

cat "$@"

printf '\n'
printf '  </table>\n'
cat src/footer.html
printf '</body>\n'
