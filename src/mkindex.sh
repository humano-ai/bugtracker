#!/bin/sh -e

cat <<EOF
<!doctype html>
<head>
  <meta charset='utf-8' />
  <title>Dillo Bug Tracker</title>
  <link rel='stylesheet' href='/style.css' type='text/css' />
</head>
<body>
  <h1>Dillo Bug Tracker</h1>
  <p>State: <a href="/">open</a> | <a href="/any.html">any</a></p>
  <table class='issue-index'>
    <tr>
      <th>Bug</th>
      <th>Title</th>
      <th>Updated</th>
      <th>State</th>
    </tr>
EOF

cat "$@"

printf '\n'
printf '  </table>\n'
cat src/footer.html
printf '</body>\n'
