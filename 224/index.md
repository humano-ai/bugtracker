Title: Render JSON content as plain text
Author: rodarima
Created: Sun, 14 Jul 2024 15:11:05 +0000
State: closed

Some website endpoints return information in JSON, which is helpful to be read as plain text in some situations.

An example is the following endpoint https://tls.browserleaks.com/tls, which provides TLS fingerprinting information in JSON, which will change when reloading the page (only when Dillo is linked with LibreSSL).

The original page https://tls.browserleaks.com/ uses JS and cannot be used in Dillo.

See: https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/message/6C5K4F6NBRUDSPNPWTXLQXCK3U3SI7DM/