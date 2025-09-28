Title: Constraint cache memory usage to a configurable limit
Author: rodarima
Created: Sun, 28 Jul 2024 14:03:57 +0000
State: open

After a long session of browsing, the cache may increase its memory requirement to a considerable amount. We should constraint the cache usage to a reasonable default (by evicting old entries) and let the user change the limit or disable it in the configuration.

Reported-by: Klaus Zimmermann

See: https://fosstodon.org/@kzimmermann/112864419033919007
See: https://kzimmermann.0x.no/articles/2024_old_computer_challenge.html