Title: Defaulted and deleted functions only available with ‘-std=c++11’
Author: rodarima
Created: Sun, 07 Jul 2024 16:51:38 +0000
State: closed

The `= default` is C++11:

```
container.hh:254:25: warning: defaulted and deleted functions only available with ‘-std=c++11’ or ‘-std=gnu++11’
  254 |       virtual ~Node() = default;
      |                         ^~~~~~~
```

Let's try to keep the std requirement at C++98.