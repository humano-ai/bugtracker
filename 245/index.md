Title: Stylesheet repush kills initial image requests
Author: rodarima
Created: Thu, 15 Aug 2024 16:30:08 +0000
State: open

Images are requested twice when style sheets cause a repush of the page. They
should continue using the original requests.

Reported-by: dogma
