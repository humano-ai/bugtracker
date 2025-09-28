Title: Print version of libraries and features
Author: rodarima
Created: Sun, 24 Nov 2024 16:13:10 +0000
State: closed

    When reporting the version of Dillo with -v, print also the version of
    the libraries it is currently using, as well as the features that were
    enabled at build time. Notice the versions are reported by reading them
    at runtime, so we can detect the version loaded at run time, regardless
    of which version was used at link time.

    All features are always printed, but prefixes with + if enabled or - if
    disabled. This allows checking if the feature was disabled at configure
    time or if it is missing in that version of Dillo.