Title: Content-Disposition causes non-root elements to open save dialogs
Author: rodarima
Created: Sun, 18 May 2025 18:40:18 +0000
State: closed

Loading https://xata.io/blog/xata-postgres-with-data-branching-and-pii-anonymization in Dillo causes several "save as" dialogs as the images and other elements contain the Content-Disposition header set:

```
$ curl -v 'https://xata.io/_next/image?url=https%3A%2F%2Fxata.io%2Fapi%2Fmedia%2Ffile%2Fcopy-on-write-branching-2.png&w=3840&q=100' |& grep dispo
< content-disposition: attachment; filename="copy-on-write-branching-2.png"
```

We should ignore the content disposition on anything that is not the root URL.