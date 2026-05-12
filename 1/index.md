Title: Slide auto-advance: avatar narrates but change_slide tool never fires
Author: Alireza
Assignee: al3rez
Created: Tue, 12 May 2026 09:22:09 +0000
State: open
Project: livetwin

During a Tavus call with a deck attached, the avatar narrates slide content out loud but the deck stays stuck on slide 1. The `change_slide` tool is never invoked, so auto-advance does not work. UI shows a "Failed" pill on tool calls.

**Status**: fixes deployed to `development`, awaiting Vercel Ready + retest.
- gpt-4o-mini → gpt-4o (commit 3a09106)
- Personalize greeting even when template has no `{{name}}` placeholder (ccc91df)
- Stamp `tavus_conversation_id` + bump `updated_at` so `change_slide` can resolve the active conversation (63c84b9)
- Backfilled `slide_texts` for deck cdae25c4 so the lecture-mode prompt loads

**Next**: retest on https://app.livetwin.ai/b673eddd-7b1d-448c-ae39-a6b5617140cf once deploy is live; confirm `Function call: change_slide` shows in Vercel logs and `current_slide_index` advances in DB.

**Update 2026-05-12**: Slide control fix via GPT-4 swap is targeted for end of today.
