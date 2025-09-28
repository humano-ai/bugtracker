Title: Mitigations against RCE vulnerabilities
Author: rodarima
Created: Sun, 14 Jul 2024 15:50:14 +0000
State: open

We may want to explore the posibility of using pledge(2) or a similar technology to limit the syscalls that can be used by the parser, or any code facing external information. The network facing code should be separated from the processing side.

The idea is to constraint posible RCE vulnerabilities to limit the posible damage it could do.

See: https://man.openbsd.org/pledge.2 https://justine.lol/pledge/