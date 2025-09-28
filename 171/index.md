Title: Avoid reaching into X509_ALGOR
Author: botovq
Created: Thu, 16 May 2024 20:16:56 +0000
State: closed

It would be nice if X509_ALGOR could be made opaque at some point. There is a somewhat clumsy accessor X509_ALGOR_get0() that allows obtaining the ASN1_OBJECT sitting inside an X509_ALGOR. Use this instead.

--%--
From: botovq
Date: Thu, 16 May 2024 20:22:56 +0000

Here's the documentation: https://www.openssl.org/docs/manmaster/man3/X509_ALGOR_get0.html
and here's the implementation:
https://github.com/openssl/openssl/blob/85ccbab216da245cf9a6503dd327072f21950d9b/crypto/asn1/x_algor.c#L72-L76

There was a signature change (const qualifiers were added) between OpenSSL 1.0.2 and 1.1, but dillo seems to assume availability of at least the OpenSSL 1.1 API.

--%--
From: rodarima
Date: Sat, 18 May 2024 18:52:20 +0000

Thanks for the patch.

> Here's the documentation: https://www.openssl.org/docs/manmaster/man3/X509_ALGOR_get0.html and here's the implementation: https://github.com/openssl/openssl/blob/85ccbab216da245cf9a6503dd327072f21950d9b/crypto/asn1/x_algor.c#L72-L76

I will assume the other parameters can be NULL based on the implementation, even if the OpenSSL documentation doesn't mention it.

> There was a signature change (const qualifiers were added) between OpenSSL 1.0.2 and 1.1, but dillo seems to assume availability of at least the OpenSSL 1.1 API.

Yes. OpenSSL 1.0 needs more patches to work, but I prefer not to add support for unmaintaned versions.