Title: Report which TLS library is selected and the version
Author: rodarima
Created: Wed, 10 Jan 2024 22:22:54 +0000
State: closed

When having multiple versions of the OpenSSL and mbedTLS libraries, it may happen that Dillo is linked with the incorrect choice. We should indicate which library is found and which version. This information should also be printed in the log, so they can be shared when reporting bugs.