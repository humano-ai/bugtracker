Title: Ignore empty page title for tab labels
Author: rodarima
Created: Tue, 11 Jun 2024 18:27:39 +0000
State: closed

When a page has an empty title like <title></title>, don't use it to set the tab label, but instead rely on the default tab label, which is computed from the file name.