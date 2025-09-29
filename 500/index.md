Title: Migrate issue tracker outside GitHub
Author: Rodrigo Arias Mallo
Created: Sun, 28 Sep 2025 20:22:13 +0200
State: open

The GitHub issue tracker has multiple issues and it doesn't work without
JavaScript. We can migrate the issues to a new issue tracker and host it
ourselves.

--%--
From: Rodrigo Arias Mallo
Date: Mon, 29 Sep 2025 21:46:37 +0200

The current implementation at https://bug.dillo-browser.org/ seems to be enough
to cover the minimal set of features we need.

However, there are some problems yet needed to be fixed. 

- The PR are imported as issues. I don't think we want to import PR, at least
  not without the patch. Maybe we can store the patch somewhere or point to the
  relevant commits in the git repo.
