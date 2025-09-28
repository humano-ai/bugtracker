Title: Add git commit to the reported version with -v
Author: rodarima
Created: Mon, 09 Dec 2024 19:05:06 +0000
State: closed

When git is available, records the git commit in the dillo binary, so dillo -v reports the version and the commit. Otherwise only the release version is reported (as we do now).

The commit is *always* recomputed when "make" is called. This allows switching branches, doing a dirty rebuild and still get the correct commit with "dillo -v".

Using AC_INIT() doesn't update the commit when the source is already configured.

Fixes: https://github.com/dillo-browser/dillo/issues/288

--%--
From: rodarima
Date: Tue, 10 Dec 2024 17:35:48 +0000

Hi @xlex8, could you test this on OpenBSD? It should detect the git commit and report it with "dillo -v". It should say exactly "Dillo v3.1.1-114-g458776d7" in the first line.

--%--
From: ghost
Date: Tue, 10 Dec 2024 19:28:20 +0000

This works:
git clone --single-branch --branch report-git-commit https://github.com/dillo-browser/
...
dillo$ src/dillo -v                                                                            
Dillo v3.1.1-114-g458776d7


--%--
From: rodarima
Date: Tue, 10 Dec 2024 19:34:34 +0000

> This works: git clone --single-branch --branch report-git-commit https://github.com/dillo-browser/ ... dillo$ src/dillo -v Dillo v3.1.1-114-g458776d7

Nice!, thanks for the check.

(Before it was failing because of the -b flag, which creates a new branch from master rather than switching to the one on the repo.)