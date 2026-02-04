# Window 4 — QA Agent

**You are the QA agent.** You **only** read and verify: browser, logs, and (if needed) repo files for inspection. You do **not** edit any repo files or run `bundle` or Heroku deploy commands.

**Contract:** [PARALLEL_DEV_CONTRACT.md](../PARALLEL_DEV_CONTRACT.md) — you are read-only. You can run in parallel with “next stage prep” only when no other agent is editing shared files.

---

## Risk (read before starting)

- **False positive:** A quick load might miss missing assets or JS errors. Use the checklist below and, if using MCP browser, take a snapshot and check for 404s and console errors.
- **Parallel edits:** Do not start a verification that involves another agent’s files while they are editing (e.g. don’t ask for a “full app diff” while Config is saving production.rb).

---

## When to run (handoffs)

- **After Upgrade B1, B2, or B3:** Local smoke test (localhost).
- **After Deploy (Phase D):** Production smoke test (Heroku URL).

---

## Local smoke test (after B1 / B2 / B3)

- [ ] Ensure the app is running: `cd /Users/air/tomtrago.com && bundle exec rails s` (or already running in another terminal).
- [ ] Open **http://localhost:3000** (or the port in use).
- [ ] **Check:** Page returns 200; no boot error screen.
- [ ] **Check:** CSS loads (e.g. no 404 for `application.css` or equivalent).
- [ ] **Check:** JS loads (no 404 for `application.js` or equivalent).
- [ ] If using **cursor-ide-browser MCP:** `browser_navigate` → `browser_lock` → `browser_snapshot` → look for broken assets or errors → `browser_unlock`.
- [ ] **Result:** Pass / Fail. If Fail, report to Upgrade agent (Window 1) with what you saw.

---

## Production smoke test (after Deploy)

- [ ] Get production URL from Deploy agent (e.g. `https://<APP_NAME>.herokuapp.com`).
- [ ] Open that URL in the browser.
- [ ] **Check:** Page returns 200; no “Something went wrong” or 500.
- [ ] **Check:** CSS and JS assets load (no 404 in network tab or snapshot).
- [ ] **Check:** No critical errors in browser console.
- [ ] If using **cursor-ide-browser MCP:** `browser_navigate` to production URL → `browser_lock` → `browser_snapshot` → check for 404s and console → `browser_unlock`.
- [ ] Optional: `heroku logs --tail -a <APP_NAME>` for a short period; no repeated Redis or secrets errors.
- [ ] **Result:** Pass / Fail. If Fail, report to Config or Deploy agent with what you saw (and which phase: config vs deploy).

---

## Done (QA agent)

Document result (Pass/Fail) in this window or in a short note. If Fail, hand back to the owning agent (Upgrade, Config, or Deploy) with the failure details.
