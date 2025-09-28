Title: Improve unit test capabilities to use code from src/
Author: rodarima
Created: Tue, 01 Apr 2025 17:58:20 +0000
State: open

Currently, unit tests are designed to test only the renderer (dw), but we could test src code as well if we split that part into an static library that is linked into the dillo binary as well as any unit test that needs it. It would help testing cases like #373. This could also be used for fuzzing tests.