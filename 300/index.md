Title: Resizing the window several times triggers the layout emergency brake
Author: rodarima
Created: Wed, 13 Nov 2024 18:28:54 +0000
State: closed

We should reset the counter of the layout loop if the window is being resized, otherwise it will lock and no more layout updates will happen.

See #236 

--%--
From: rodarima
Date: Wed, 13 Nov 2024 19:41:38 +0000

There are multiple Layout instances in a single tab and each is currently using its own resizeCounter. This is used for ComplexButtonResource. We may want to use it only in the top level one, otherwise each sub-layout may break at different times.