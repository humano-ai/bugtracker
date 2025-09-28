Title: Preserve aspect ratio of images
Author: rodarima
Created: Mon, 12 Aug 2024 22:01:47 +0000
State: closed

A common problem for images is that only one dimension is given {height,width}
or that a range is set by {min,max}-{height,width}. Previously, the original
size of the image was used to compute the aspect ratio and then fill the missing
dimension.

But the procedure requires more steps to fulfill all constraints. This PR tries
to cover all posible cases of constrained images while preserving the aspect
ratio. When is not posible, the aspect ratio is distorted to fit the size
constraints.


### TODO

- [x] Test several combinations of padding and margins to check we continue to
  compute the image size correctly. -> Tested manually, but we may want to add more render tests to the suite.
- [x] Test floating images and cases where they might not have a parent.
- [x] Check the problem with gigantic images is not introduced by this PR.

---

<details>
<summary>How it looks</summary>
Before:

![image](https://github.com/user-attachments/assets/67426e04-b312-4184-bf9a-b6537c2389e7)

After:

![image](https://github.com/user-attachments/assets/6d0b172a-3391-4a6d-b078-05e1b9ae4584)

</details>

--%--
From: rodarima
Date: Thu, 17 Oct 2024 18:47:53 +0000

Testing with float images improves when compared with the previous behavior, but continues to show problems when computing the parent requisition. I think we can leave this for a future PR, to avoid stalling this one forever.