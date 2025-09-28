Title: Multiple floated items are clearing when they shouldn't
Author: campaul
Created: Mon, 02 Jun 2025 17:38:09 +0000
State: open

Given the following example:

```html
<html>
    <head>
        <style type="text/css">
            div {
                width: 100px;
                height: 100px;
                margin: 10px;
                border: 5px solid black;
                float: left;
            }
        </style>
    </head>
    <body>
        <div>A</div>
        <div>B</div>
    </body>
</html>
```

## Expected Result (taken from Firefox)
![Image](https://github.com/user-attachments/assets/c6af65ef-facb-4245-b108-910d69993612)

## Actual Result
![Image](https://github.com/user-attachments/assets/d2858778-93ec-4137-ad61-19b84f17f18c)