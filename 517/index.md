Title: Cannot jump between comments in Hacker News
Author: Rodrigo Arias Mallo
Created: Sun, 01 Feb 2026 18:17:32 +0100
State: open

When clicking on the next, prev or parent link of a HN comment, dillo scrolls to
the bottom instead of the actual comment. Same when opening a link with the
anchor:

<https://news.ycombinator.com/item?id=38847613#38849048>

This seems to be happening because the id is the `<tr>` element as if this were
replaced by the upvote button (which is an `<a>` tag) then it works:

    $ dilloc dump | sed 's/href="#\([0-9]\+\)"/href="#up_\1"/g' | dilloc load

Reported by `nmz` via IRC.
