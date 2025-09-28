#!/bin/sh

n=$(printf '%s\n' [0-9]* | sort -nr | head -1)
if [ -z "$n" ]; then
  n=1
else
  let n=n+1
fi

mkdir $n
p=$n/index.md

echo "Title: " >> $p
echo "Author: $(git config get user.name)" >> $p
echo "Created: $(date -R)" >> $p
echo "State: open" >> $p

echo "\$EDITOR $n/index.md"
