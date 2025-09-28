Title: Check build with old C++ standards
Author: rodarima
Created: Fri, 21 Jun 2024 18:25:05 +0000
State: closed

The static_assert fails with standards older than C++11, so we may want to only enable it if available. So far it seems to build with C++03.