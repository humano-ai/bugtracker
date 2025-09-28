Title: Improve Concomitant Control Chain (CCC) design
Author: rodarima
Created: Sun, 14 Jul 2024 20:26:49 +0000
State: open

This may require a RFC.

The CCC has several problems, and they will become blockers to design a flexible mechanism to allow intercepting traffic along the path of the chain.

- Doesn't support multiple threads/processes operating concurrently or reentrancy. This prevents us from using external tools to manipulate the flow of information through the chains.

- It is designed to handle all connections from and to a node, which makes it really hard to understand which connection is which:

```
       +---+
--->---|   |--->---
       | X |
---<---|   |---<---
       +---+
```

- The control commands are coupled with the I/O operations.

```c
/*
 * Supported CCC operations
 */
#define OpStart  1
#define OpSend   2
#define OpStop   3
#define OpEnd    4
#define OpAbort  5
```
This causes very long switches to control what we should do on each case:
https://github.com/dillo-browser/dillo/blob/8f0909b7ae431a0c4a8e5b49ed4348624fdfe11e/src/IO/IO.c#L367-L469

---

A posible solution is to split the chain into two bidirectional channels, much like in Go:

```
+---+       
|   |--->---
| X |       
|   |---<---
+---+       
```

And use the methods write and read to determine the direction of the data. This allows defining a callback function that will encode only one case of the switch and encourages a simpler design.

Example of a simple callback that forwards a received message in a channel to either a "filter" channel if it is configured to intercept them, or directly to the output channel if not:

```c
/* Called on new data */
int io_read_cb(Chan *c, Msg *m)
{
    Foo *foo = c->context;
    if (foo->intercept)
        return chan_write(foo->filter, m);
    else
        return chan_write(foo->output, m);
}
```

The errors are propagated by simply returning the proper error code.

It also would allow using an internal FIFO or similar file descriptor, which is transparently used when the endpoint is in another process.

--%--
From: rodarima
Date: Mon, 15 Jul 2024 19:24:09 +0000

Another problem with the current design is that every time some new data is passed along the http step of the chain, there is the need to find out the context of that chain, which is done using a number (key) for the Http chain link. This requires having a global table where to perform a lookup to get the information of the current chain data.

https://github.com/dillo-browser/dillo/blob/8f0909b7ae431a0c4a8e5b49ed4348624fdfe11e/src/IO/http.c#L884

https://github.com/dillo-browser/dillo/blob/8f0909b7ae431a0c4a8e5b49ed4348624fdfe11e/src/IO/http.c#L924

This is not required, as we could just store a pointer in the chain link itself, one for each side. They each side just uses that pointer to hold context information to the chain, like with IO and Capi. This has O(1) complexity.