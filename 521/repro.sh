#!/bin/sh

export TZ=GMT
export LANG=C

while [ 1 ]; do

  server_date=$(date "+%a, %d %Y %b %T %Z")
  expire_date=$(date -d "+120 seconds" "+%a, %d %Y %b %T %Z")

  echo "HTTP/1.1 302 Found
Content-Length: 0
Date: ${server_date}
Location: /beep
Set-Cookie: foo=bar; Path=/beep; Domain=127.0.0.1; Expires=${expire_date}; Max-Age=120; HttpOnly; SameSite=Lax
" | \
  nc -l 8080

done
