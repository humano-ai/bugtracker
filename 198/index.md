Title: Integrate a search mode in the location bar
Author: rodarima
Created: Fri, 14 Jun 2024 20:18:26 +0000
State: open

The current UX of opening a search engine is a bit cumbersome when using the search dialog (Ctrl+S). While we have the shortcuts that we can use to prefix a search in the location bar, for example "dd flying ducks" would search "flying ducks" on DuckDuckGo.

Most of the search begin from an already loaded page, so I would suggest a different (optional) workflow. Press Ctrl+S to switch the location bar to search mode (we can mark it properly as such, and add the search engine menu to change the default). Then type the search query "flying ducks" and then decide if you want to open the results in the current page (Enter) or in another tab (Shift+Enter).

This is a quicker method to do a search without changing the current context in which the search is done. It also allows the user to copy or read information from the current page while typing the query. It also has the benefit that the user will know at any time if the location bar is in URL or search mode, so **you can search for an url without worrying it will try to open it**.

We can retain the current search prefixes in the search mode too, so we can switch to other search engines in the same way as before too.