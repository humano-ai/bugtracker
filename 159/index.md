Title: Issuer Certificate of an Untrusted Certificate 
Author: ktnb-netbsd
Created: Mon, 06 May 2024 17:15:42 +0000
State: closed

Hi,

I'm working on updating the version of dillo in pkgsrc (for NetBSD) and I'm receiving this error every time I attempt to go to an site via HTTPS: 
> The issuer certificate of an untrusted certificate cannot be found. Issuer: /C=US/O=DigiCertInc/OU=www.digicert.com/CN=DigiCert Global Root G2

Is this normal?

EDIT: It's not always DigiCert but the error is the same otherwise.

--%--
From: rodarima
Date: Mon, 06 May 2024 17:29:36 +0000

No, is not normal. It can happen if Dillo cannot find the CA bundle. Does it show some messages in the console at the start?

Check also the configure options --with-ca-certs-file and --with-ca-certs-dir. We may need to add a note in the install docs.

--%--
From: ktnb-netbsd
Date: Mon, 06 May 2024 17:45:19 +0000

> No, is not normal. It can happen if Dillo cannot find the CA bundle. Does it show some messages in the console at the start?

No, there isn't any warning about certs. Just missing configs.

> Check also the configure options --with-ca-certs-file and --with-ca-certs-dir. We may need to add a note in the install docs.

I'll give this a try and get back to you.

--%--
From: ktnb-netbsd
Date: Mon, 06 May 2024 17:59:42 +0000

> Check also the configure options --with-ca-certs-file and --with-ca-certs-dir.

Setting --with-ca-certs-dir fixes it. Thank you!