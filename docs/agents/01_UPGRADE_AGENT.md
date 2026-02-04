# Window 1 — Upgrade Agent

**You are the Upgrade agent.** You are the **only** agent that edits `Gemfile`, runs `bundle`, and runs `rails app:update`. Do not run Config or Deploy steps in this window.

**Contract:** [PARALLEL_DEV_CONTRACT.md](../PARALLEL_DEV_CONTRACT.md) — you own Gemfile and app:update outputs during B1–B3.

---

## Risk (read before starting)

- **Conflict:** If Config agent edits `config/environments/production.rb` or `config/cable.yml` while you are working, you can get merge conflicts or a broken app. Only run your steps when no one else is editing those files (Config runs after you finish Stage 3).
- **Broken state:** Do not run `bundle exec rails s` or run the app in production mode until Config has fixed production.rb (encrypted secrets and cable Redis). Local development should still work after each stage.

---

## Pre-flight

- [ ] Repo is on branch `upgrade-ruby-rails-heroku` (create if needed: `git checkout -b upgrade-ruby-rails-heroku`).
- [ ] No uncommitted changes from another agent (run `git status`).

---

## Phase A — Branch and baseline

- [ ] `cd /Users/air/tomtrago.com`
- [ ] `git checkout -b upgrade-ruby-rails-heroku` (if branch does not exist).
- [ ] Optional: `bundle exec rails -v` and `bundle exec rails s` to confirm current app boots (if it fails on secrets, note it; Config will fix later).
- [ ] **Handoff to QA (optional):** If you want a baseline, tell QA to open localhost and snapshot once.

---

## Phase B1 — Rails 5.2

- [ ] Edit **Gemfile:** set `gem "rails", "~> 5.2.8"` (keep current `ruby` line).
- [ ] Run: `bundle update rails`
- [ ] Run: `bundle exec rails app:update` — resolve config conflicts; keep app-specific settings.
- [ ] Commit: `git add -A && git commit -m "Upgrade Rails to 5.2.x"`
- [ ] **Handoff:** Tell QA to run local smoke test (Window 4). Do not start B2 until you’re ready (QA can run in parallel with your next step if you’re not editing the same files).

---

## Phase B2 — Ruby 3.2 + Rails 6.1

- [ ] Edit **Gemfile:**
  - `ruby "3.2.8"`
  - `gem "rails", "~> 6.1.7"`
  - `gem "puma", "~> 6.4"`
- [ ] Run: `bundle update --bundler`
- [ ] Run: `bundle update rails puma`
- [ ] Run: `bundle exec rails app:update`
- [ ] Run: `bundle exec rails zeitwerk:check` — fix any reported issues.
- [ ] Commit: `git add -A && git commit -m "Upgrade Ruby to 3.2.8 and Rails to 6.1.x"`
- [ ] **Handoff:** Tell QA to run local smoke test.

---

## Phase B3 — Ruby 3.4.7 + Rails 7.2.2

- [ ] Edit **Gemfile:**
  - `ruby "3.4.7"`
  - `gem "rails", "7.2.2"`
  - Remove: `gem "sass-rails"`, `gem "uglifier"`
  - Add: `gem "sassc-rails"`, `gem "terser"`
  - Bump if present: `pg` to `~> 1.5`, `autoprefixer-rails` to `>= 10.0`
- [ ] Run: `bundle update`
- [ ] Run: `bundle exec rails app:update`
- [ ] Run: `bundle exec rails zeitwerk:check`
- [ ] **Do not** edit `config/environments/production.rb` or `config/cable.yml` — Config agent owns those in Phase C.
- [ ] Commit: `git add -A && git commit -m "Upgrade to Ruby 3.4.7 and Rails 7.2.2"`
- [ ] **Handoff:** Tell QA to run local smoke test. Then tell **Config agent (Window 2)** to run Phase C.

---

## Done (Upgrade agent)

After B3 and commit, your work is complete. Config agent will fix production boot and cable; then Deploy; then QA will verify production.
