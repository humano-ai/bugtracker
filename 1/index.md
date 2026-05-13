Title: Slide auto-advance: avatar narrates but change_slide tool never fires
Author: Alireza
Assignee: al3rez
Created: Tue, 12 May 2026 09:22:09 +0000
State: uat
Project: livetwin

During a Tavus call with a deck attached, the avatar narrates slide content out loud but the deck stays stuck on slide 1. The `change_slide` tool is never invoked, so auto-advance does not work. UI shows a "Failed" pill on tool calls.

**Status**: UAT after the self-driving multi-slide lecture fix was pushed to `development`.
- gpt-4o-mini → gpt-4o (commit 3a09106)
- Personalize greeting even when template has no `{{name}}` placeholder (ccc91df)
- Stamp `tavus_conversation_id` + bump `updated_at` so `change_slide` can resolve the active conversation (63c84b9)
- Backfilled `slide_texts` for deck cdae25c4 so the lecture-mode prompt loads
- Self-driving multi-slide lecture chain pushed in d7c8783: narration accumulator stitches all assistant narrations in the `runTools` chain, cap raised to 25 chained completions, prompt now requires repeated `narrate → change_slide` within one LLM turn.

**Next / UAT**: wait for Vercel deploy, retest on https://app.livetwin.ai/b673eddd-7b1d-448c-ae39-a6b5617140cf, and confirm one POST to `/api/v1/chat/completions` produces multiple `Function call: change_slide` logs while `current_slide_index` advances through the deck.

**Update 2026-05-12**: Slide control fix via GPT-4 swap is targeted for end of today.

--%--
From: Claude
Date: Wed, 13 May 2026 13:12:45 +0000

Pushed d7c8783 on `development`:

- **route.ts**: narration accumulator now collects content from every assistant message in the `runTools` chain (not just the final one), so multi-step `narrate → change_slide → narrate → change_slide` flows stitch all narrations into one Tavus response. Chained completions cap raised to 25.
- **Lecture prompt rewrite**: explicit self-driving instructions — multiple `change_slide` calls per response are required and expected. Handles viewer interrupts (pause + answer), affirmatives ("ok", "got it" → keep chaining), and back-nav ("go back to slide 3" → `prev`/`goto` then re-narrate).

Next: wait for Vercel deploy, retest call, confirm a single POST to `/api/v1/chat/completions` produces multiple `change_slide` tool calls and the avatar auto-advances through the deck.
