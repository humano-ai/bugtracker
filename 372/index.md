Title: Save page dialog has broken filename input
Author: acmiyaguchi
Created: Thu, 20 Mar 2025 01:53:55 +0000
State: open

![Image](https://github.com/user-attachments/assets/bfd23e7f-7993-4c32-92ba-767bf7c4a777)

When the `save_dir` property is set to `~/`, the filename input is broken. You can remove the `/tmp` part of the text in one backspace, where it then shows the correct path. If you put the full expanded path, then it works as intended.