Title: Fix heap use after free in TLS conn on errors
Author: rodarima
Created: Wed, 28 Aug 2024 22:43:21 +0000
State: closed

When a error causes the TLS connection to fail and stop, the conn struct is free on Tls_close_by_key(), so writing to conn->in_connect is not correct after that point. The solution is to only set the flag when the it is still valid.

Reported-by: Alex <a1ex@dismail.de>
Link: https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/thread/TY2JYCIPC7IQ32U6VC7ZOV3FVFFOE5K3/