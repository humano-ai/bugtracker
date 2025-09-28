Title: Disable "Layout::resizeIdle calls" message
Author: rodarima
Created: Fri, 03 May 2024 16:35:43 +0000
State: closed

It is always shown, even when messages are turned of by "show_msg=NO", as the preferences are not available to dw. For now we disable it permanently by using the _MSG() macro.

Reported-by: Kevin Koster <dillo@ombertech.com>
See: https://lists.mailman3.com/hyperkitty/list/dillo-dev@mailman3.com/message/PPNR5FTO3YFDVAQCM4SDNVAF22JEV22W/