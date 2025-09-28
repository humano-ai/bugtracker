Title: Fix FLTK version for old releases
Author: rodarima
Created: Tue, 10 Dec 2024 20:44:27 +0000
State: closed

The returned value from Fl::version() is a floating point number like 1.0303, not 10303, so we correct it to follow Fl::api_version().