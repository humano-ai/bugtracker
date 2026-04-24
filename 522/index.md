Title: Add context menu for selected text
Author: Rodrigo Arias Mallo
Created: Fri, 24 Apr 2026 21:36:11 +0200
State: open

By providing a context menu for a selection of text we can include support for
actions such as:

- Search word in dictionary: Use the selected word(s) as a query to an online
  dictionary. Easy to do with `dilloc open`.

- Translate: Query a service to translate the selected text.

- Save as note: Record the website and selection in a local file for posterior
  lookup.

We probably would also need support for a dilloc subcommand to handle the
selected text, so it can be agnostic to the window manager.
