Title: Add event debugging mechanism
Author: rodarima
Created: Tue, 12 Mar 2024 21:18:59 +0000
State: open

Similarly as the RTFL tools, we need a way to record step by step how the layouting engine is processing the tree. It is not enough that we show the last values of the widget tree as the [debug window is currently doing](https://github.com/dillo-browser/dillo/issues/40).

In particular, I'm observing problems such as widget computing the available space by asking up in the tree until the root several times. This computation must be cached, as once a parent widget has computed the available size it shouldn't change until we finish the sizeRequest.

I'm thinking in adding a debugging mode in which Dillo records the last sizeRequests in a list, so we can explore one by one. Then, we also record the calls done by every widget, similarly as RTFL, but displayed directly on the browser. The idea is that we already distribute all the tools to debug problems builtin, so other people can take a look at what may be happening with low effort.

Ideally we should be able to turn it on only when the user requests it, otherwise we will introduce a lot of performance and memory problems.

--%--
From: rodarima
Date: Sun, 17 Mar 2024 09:11:30 +0000

Here is an example using a tree, where we instrument some functions, much like RTFL:

![kk](https://github.com/dillo-browser/dillo/assets/3866127/59c249ef-065d-4c73-bf68-ae7b65541b4f)

The difference is we can expand the nodes interactively, which helps hiding information that is not relevant.
