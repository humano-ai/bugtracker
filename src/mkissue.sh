#!/bin/sh -e

sed 's/ #\([0-9]\+\)/ [#\1](\1\/)/g' $1 | \
	awk -f src/issue.awk | \
	md2html --github
