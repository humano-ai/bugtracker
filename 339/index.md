Title: Print error if dpi_dir cannot be opened
Author: rodarima
Created: Fri, 17 Jan 2025 20:02:51 +0000
State: closed

On cases where the system directory cannot be opened, dpid will not load the builtin plugins causing Dillo to fail to work properly with file: or data: URLs. Reporting a failure to open the directory allows users to determine the cause of the problem.

See: https://github.com/dillo-browser/dillo/issues/337