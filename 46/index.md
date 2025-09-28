Title: Add automatic rendering tests
Author: rodarima
Created: Sat, 30 Dec 2023 20:04:19 +0000
State: closed

These tests render a HTML page in Dillo and save a screenshot which is compared with another one rendered by a reference HTML file which doesn't make use of the feature under test.

Running these tests require some additional dependencies to run a Xorg server and capture screenshots of the browser, so they are only enabled when configured with the --enable-html-tests option.

Additionally, running Dillo and opening local files requires a working file dpi plugin. So, when running the HTML tests it is required that a working dpid server can be launched by Dillo. To do so, Dillo can be first installed to a prefix directory, the dpidrc file copied to ~/.dillo/ and then the DILLOBIN variable set to the path of the dillo binary under test.

Implements #15 