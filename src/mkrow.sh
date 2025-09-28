#!/bin/sh -e

n=$1
f=$2
s=$3

title=$(head -1 $f | sed 's/^Title: //')
modif=$(stat -c %y $f | cut -d ' ' -f 1)

awk -v n=$n -v s="$s" -v modif="$modif" -f src/issue-entry.awk < $f
