Title: Zooming out makes 1 px border dissapear
Author: rodarima
Created: Sun, 11 Aug 2024 20:20:31 +0000
State: closed

When zooming out of a page that uses a 1 px border, the border disappears. We
could make a rule to prevent applying the zoom to the border.

The problem is likely coming from the zoom computation:

```c
bool StyleEngine::computeValue (int *dest, CssLength value, Font *font) { 
   switch (CSS_LENGTH_TYPE (value)) { 
      case CSS_LENGTH_TYPE_PX: 
         *dest = (int) (CSS_LENGTH_VALUE (value) * zoom); 
         return true; 
```

As soon as the floating point value drops below 1, the value is converted to 0.
However, if we round it, it will need to at least drop below 0.5, at which point
it would be fine if it disappears.
