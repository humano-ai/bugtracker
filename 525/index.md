Title: Failed cases in cookies unit test
Author: Rodrigo Arias Mallo
Created: Wed, 29 Apr 2026 21:54:55 +0200
State: open

It looks like the cookies unit test has some failed test cases, which doesn't
seem to be related to our max-age fix (tested with previous commit).

    % ./cookies
    TESTS: passed: 121 failed: 4

    line 634: EXPECTED:  GOT: Cookie: name=val

    line 654: EXPECTED:  GOT: Cookie: name=val

    line 665: EXPECTED:  GOT: Cookie: name=val

    line 676: EXPECTED:  GOT: Cookie: name=val

    TESTS: passed: 121 failed: 4
    Now that everything is full of fake cookies, you should run 'dpidc stop', plus delete cookies.txt if necessary.

We need to run it from the CI pipeline otherwise it won't catch new problems.

Perhaps it may be a way to run it so that we don't need to touch the user
configuration (in `cookiesrc`) or overwrite any cookies.
