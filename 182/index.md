Title: Remove undefined floatRef debug line in RTFL
Author: rodarima
Created: Sun, 02 Jun 2024 18:03:03 +0000
State: closed

Fixes: https://bugs.gentoo.org/933361

CC @asarubbo @Kangie 

**Note:** The `--enable-rtfl` flag will cause *a lot* of printf lines which are used to debug the rendering engine (with another tool called RTFL). They are not recommended while browsing as a user as they will slowdown the browser a lot.