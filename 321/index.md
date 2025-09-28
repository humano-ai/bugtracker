Title: Avoid rebuild when the git commit is the same
Author: rodarima
Created: Wed, 11 Dec 2024 21:58:29 +0000
State: closed

Compare the commit used in the last rebuild to determine if it has changed, rather than using a phony target which always causes a rebuild.