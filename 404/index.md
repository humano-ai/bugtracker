Title: blockquote and dd render incorrectly with float
Author: campaul
Created: Thu, 29 May 2025 22:34:10 +0000
State: open

The `blockquote` and `dd` tags render incorrectly when float is applied. I suspect this has something to do with the `Html_tag_open_blockquote` and `Html_tag_open_dd` functions but I haven't been able to fully isolate the issue yet.

The screenshots below are based on the following style:
```css
blockquote {
  border-style: solid;
  border-color: black;
  width: 50px;
  height: 50px;
  float: left;
  background-color: #FC0;
  color: black;
  margin: 10px;
}
```

## Expected Behavior
![Image](https://github.com/user-attachments/assets/c7ad8155-a38b-4fea-b100-5c8d69969b6e)

## Current Behavior
![Image](https://github.com/user-attachments/assets/bcaec188-1c8d-422b-9dd7-46e8da81cd6b)