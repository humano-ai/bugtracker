#!/bin/sh -e

n=$1
f=$2
s=$3
p=$4
a=$5

title=$(head -1 $f | sed 's/^Title: //')
if stat -c %y "$f" >/dev/null 2>&1; then
  modif=$(stat -c %y "$f" | cut -d ' ' -f 1)
else
  modif=$(stat -f %Sm -t %F "$f")
fi

awk -v n=$n -v s="$s" -v p="$p" -v a="$a" -v modif="$modif" -f src/issue-entry.awk < $f
