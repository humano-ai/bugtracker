Title: Add support for SameSite in cookies
Author: Rodrigo Arias Mallo
Created: Fri, 07 Nov 2025 22:00:41 +0100
State: open

In order to help mitigate CSRF attacks on sites that don't provide any
additional protection we may want to add support for the SameSite attribute in
cookies. If it is not specified we set by default the Strict or Lax value, which
would prevent cookies from being sent after a redirection from a attacker site
to the unprotected site.

The SameSite attribute is not yet part of an official RFC, but it seems that it
may get accepted:

<https://datatracker.ietf.org/doc/draft-ietf-httpbis-layered-cookies/>
