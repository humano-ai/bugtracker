# Dillo bug tracker

This repository contains the issues for the Dillo web browser. Each issue is
contained in a directory named with the issue number. The text of the issue
is stored in the index.md markdown file and any extra attachments are placed
inside the issue directory.

Issue metadata follows the email headers, example:

    Title: Indentation error on cgit diff
    Author: Rodrigo Arias Mallo
    Created: Sun, 28 Sep 2025 14:44:28 +0200
    State: open

    Indentation with tabs in cgit diff seems to be broken, elements don't get
    aligned as expected.

Comments are added in the same file by including the separator `--%--` and
additional headers:

    --%--
    From: rodarima
    Date: 2025-08-23 13:33:46+00:00

    So, there are two issues here:

The format of the issues is barely restricted, so direct HTML can be included to
include HTML reproducers inline.

To modify the issues, edit directly the index.md file and run `make` to render
the output before pushing the changes to upstream.

To close an issue simply change the `State: open` line to `State: closed`.
