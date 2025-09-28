Title: Improve Wikipedia math rendering
Author: rodarima
Created: Sat, 06 Jul 2024 21:04:52 +0000
State: open

We'll have to fix several problems:
- [x] Implement support for SVG with references: #211 
- [ ] Improve support for ex units as they are used to control math equation sizes and currently they are sometimes too small.
- [x] Add support for rem units as they are used to set the padding: #264 
- [ ] Implement support for `var()` custom variables as they control the line-height.

Test pages:
- https://en.wikipedia.org/wiki/Maxwell%27s_equations
- https://en.wikipedia.org/wiki/Quantum_entanglement
- https://en.wikipedia.org/wiki/Wave_function
- https://en.wikipedia.org/wiki/Dirac_delta_function
- https://en.wikipedia.org/wiki/Fourier_transform
- https://mathworld.wolfram.com/FourierTransform.html
- https://en.wikisource.org/wiki/On_Einstein%27s_Theory_of_gravitation