Title: Add support to use an external password manager
Author: rodarima
Created: Sat, 17 Aug 2024 23:46:49 +0000
State: open

Dillo should be able to store user/password information (and potentially others)
in a safe way, so that it is remembered in the future.

A potential solution is to add support for external password managers so we
don't need to implement it ourselves.

See: https://xn--4pv.arzinfo.eu.org/Otyugh/p/1723455843.925137
See: https://brutaldon.org/thread/112948402411922456


--%--
From: rodarima
Date: Sun, 25 Aug 2024 19:18:11 +0000

Firefox Sync can store passwords too with the ffsclient: https://github.com/Mikescher/firefox-sync-client

--%--
From: jn64
Date: Sun, 02 Mar 2025 03:39:49 +0000

I think these are separate concerns:

1. "Dillo should be able to store user/password information."
2. "Dillo should support external password manager(s)."

### "Dillo should be able to store user/password information."

1 is much more useful for a browser. It means anyone can start using Dillo,
login to a website, maybe get a prompt "Do you want Dillo to save passwords?"
and click yes, regardless if they use any password manager or even
understand the concept.

On mainstream Linux this might be done with [freedesktop Secret Service API](https://specifications.freedesktop.org/secret-service-spec/latest/)
(see also [libsecret](https://gnome.pages.gitlab.gnome.org/libsecret/)). Users often have one of [gnome-keyring](https://wiki.archlinux.org/title/GNOME/Keyring) or [kwallet](https://wiki.archlinux.org/title/Kwallet) (KDE Wallet),
even if they don't use GNOME or KDE and don't explicitly use these as
password managers, because they are used by other apps to store secrets
(e.g. NetworkManager, Evolution mail client).

(Just examples. I don't know if this is a good fit for Dillo.
libsecret seems to be available in FreeBSD as well.)

### "Dillo should support external password manager(s)."

2 is much less useful. Users who already use a password manager
probably wouldn't want to use a different one just for Dillo.

Also, password manager users may not need or want this support.
I use [KeepassXC](https://keepassxc.org), and I intentionally do not install its browser extension(s).

I only save passwords into KeepassXC directly, and use passwords in other
apps by invoking a global hotkey for KeepassXC to type a chosen password.
This way all apps have the same workflow; browser, terminal, any window
that can be focused and accepts keyboard input.

I don't need to worry if any app has integration with my specific password
manager, or if that integration is correct or maintained.

So, I can already use my password manager with Dillo. I suspect most other
intentional password manager users can also do this.
