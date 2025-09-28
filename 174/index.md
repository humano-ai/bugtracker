Title: Use fixed width integers for CSS length type
Author: rodarima
Created: Sat, 25 May 2024 23:10:31 +0000
State: closed

The current type for a CSS "length" like `80px` or `20%` is represented internally as a single `int` type, which doesn't have a fixed length. In C and C++, there is only a guarantee that an int will hold at least 16 bits, but the current assumption is that it will hold at least 32 bits.
```
| <------   integer value   ------> |

+---+ - - - +---+---+- - - - - -+---+---+---+---+
|          integer part             |   type    |
+---+ - - - +---+---+- - - - - -+---+---+---+---+
| integer part  | decimal fraction  |   type    |
+---+ - - - +---+---+- - - - - -+---+---+---+---+
 n-1          15  14              3   2  1   0

| <------ fixed point value ------> |
```

Furthermore, as we introduce more length types we are going to run out of length bits for the value itself. A simple option could be to define the length as something like this:

```c
typedef struct CssLength {
    CssLengthType type;
    union {
        int i;
        float f;
    };
} CssLength;
```

Which will duplicate the size required to store lengths to 64 bits, as the type will likely use 32 bits with padding and another 32 bits for the integer/float value (on 64 bits machines). It has the benefit that on 16 bits machines, the size will halve to 32 bits, as all members will reduce their size.

--%--
From: kalvdans
Date: Wed, 12 Jun 2024 20:44:41 +0000

As a first step maybe use `int32_t` for the type to make sure we get 32 bits even on 16-bit platforms?

--%--
From: rodarima
Date: Sat, 05 Oct 2024 17:28:01 +0000

Merged in #264 