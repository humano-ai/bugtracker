Title: Fix ASan new-delete-type-mismatch error
Author: rodarima
Created: Sat, 06 Jul 2024 10:02:23 +0000
State: closed

With the adreess sanitizer enabled there was an error:

>  AddressSanitizer: new-delete-type-mismatch

Caused by a size mismatch in the delete operator as the called destructor was the incorrect one.