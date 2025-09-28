Title: misc.hh: error: class lout::misc::NotSoSimpleVector<T> has no member named arrayExtra
Author: rodarima
Created: Thu, 17 Oct 2024 07:56:36 +0000
State: closed

From: https://bugs.gentoo.org/939137

```
In file included from object.hh:7,
                 from container.hh:4,
                 from container.cc:23:
misc.hh: In copy constructor lout::misc::NotSoSimpleVector<T>::NotSoSimpleVector(const lout::misc::NotSoSimpleVector<T>&):
misc.hh:384:13: error: class lout::misc::NotSoSimpleVector<T> has no member named arrayExtra; did you mean arrayExtra1? [-Wtemplate-body]
  384 |       this->arrayExtra = NULL;
      |             ^~~~~~~~~~
```

It seems we left an outdated constructor. This was caught by gcc 15.