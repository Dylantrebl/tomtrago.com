# Upgrade Plan: Rails 5.1 / Ruby 2.5 → Rails 7.2 / Ruby 3.4 (Heroku)

**Repo:** tomtrago.com  
**Target:** Ruby 3.4.7, Rails 7.2.2, Heroku stack heroku-24  
**Approach:** Staged upgrades + multiple agents + MCP tools for verification and automation.

---

## Repo-specific notes (tomtrago.com)

- **Ruby in Gemfile:** currently `2.5.0` (not 2.5.5); upgrade path is the same.
- **No Sidekiq/Redis in Gemfile:** app has ActionCable and `config/cable.yml` production pointing at localhost; no `event_update_worker` or `continue` → `next` fix needed unless you add workers later.
- **Secrets:** `config/secrets.yml` is unencrypted; production uses `ENV["SECRET_KEY_BASE"]`. Removing `config.read_encrypted_secrets = true` in production is required so the app doesn’t try to load missing `secrets.yml.enc`.
- **Assets:** Uses `sass-rails` and `uglifier`; these will be replaced with `sassc-rails` and `terser` in Stage 3.

---

## Agent roles and MCP usage

| Role | Responsibilities | MCP / tools |
|------|------------------|--------------|
| **Upgrade agent** | Gemfile edits, `bundle update`, `rails app:update`, version bumps, commits per stage. | Terminal, **user-filesystem** (read/write Gemfile, config files). |
| **Config agent** | Production boot fixes: remove encrypted-secrets toggle, fix cable.yml Redis, asset compressor. | **user-filesystem** or Cursor edits: `config/environments/production.rb`, `config/cable.yml`. |
| **Deploy agent** | Heroku stack, buildpacks, add-ons, config vars, push and migrate. | Terminal (Heroku CLI), **user-filesystem** if writing scripts or docs. |
| **QA agent** | Smoke-test after each stage locally; after deploy, verify production URL and assets. | **cursor-ide-browser**: navigate to localhost and Heroku URL, snapshot, check for 404s and console errors. |
| **Analysis (optional)** | Pre/post upgrade: analyze Gemfile or config for compatibility. | **user-gateway** `gateway_analyze_code` on selected code snippets. |

---

## MCP tool usage in detail

### cursor-ide-browser

- **When:** After Stage 1, 2, 3 (local) and after Heroku deploy.
- **Flow:** `browser_navigate` → `browser_lock` → `browser_snapshot` → check for 200, no asset 404s, no critical JS errors → `browser_unlock`.
- **URLs:** Local: `http://localhost:3000` (or whatever port); Production: `https://<APP_NAME>.herokuapp.com`.

### user-filesystem

- **When:** Any step that reads or writes repo files (Gemfile, configs, initializers).
- **Use:** `read_file` / `read_multiple_files` before edits; `write_file` or `edit_file` for changes. Keeps file ops explicit and auditable.

### user-gateway

- **When (optional):** Before Stage 1, pass Gemfile + production.rb snippet to `gateway_analyze_code` for upgrade/optimization notes. After config changes, optionally re-analyze to double-check.

---

## Phase A) Branch and baseline

**Owner:** Upgrade agent (or single Cursor agent).

1. Create branch:
   ```bash
   cd /Users/air/tomtrago.com
   git checkout -b upgrade-ruby-rails-heroku
   ```
2. (Optional) Confirm current app boots:
   ```bash
   bundle exec rails -v
   bundle exec rails s
   ```
   If it fails (e.g. encrypted secrets), note it; Config agent will fix before production deploy.
3. (Optional) **QA agent** with **cursor-ide-browser:** open `http://localhost:3000`, snapshot, record baseline (homepage loads, any existing 404s).

---

## Phase B) Staged upgrades (Upgrade agent)

Do in order; commit after each stage.

### Stage 1: Rails 5.2 (keep current Ruby)

1. **Edit Gemfile** (e.g. via Cursor or **user-filesystem**):
   - `gem "rails", "~> 5.2.8"`
2. Run:
   ```bash
   bundle update rails
   bundle exec rails app:update
   ```
   Resolve conflicts in config/ if any; prefer keeping app-specific settings.
3. Commit: `git add -A && git commit -m "Upgrade Rails to 5.2.x"`
4. **QA:** Start server, **cursor-ide-browser** quick check on localhost.

### Stage 2: Ruby 3.2 + Rails 6.1

1. **Edit Gemfile:**
   - `ruby "3.2.8"`
   - `gem "rails", "~> 6.1.7"`
   - `gem "puma", "~> 6.4"`
2. Run:
   ```bash
   bundle update --bundler
   bundle update rails puma
   bundle exec rails app:update
   bundle exec rails zeitwerk:check
   ```
3. Fix any deprecations or Zeitwerk issues reported.
4. Commit: `git add -A && git commit -m "Upgrade Ruby to 3.2.8 and Rails to 6.1.x"`
5. **QA:** Local smoke-test with browser MCP.

### Stage 3: Ruby 3.4.7 + Rails 7.2.2

1. **Edit Gemfile:**
   - `ruby "3.4.7"`
   - `gem "rails", "7.2.2"`
   - Remove: `sass-rails`, `uglifier`
   - Add: `gem "sassc-rails"`, `gem "terser"`
   - Bump if present: `pg` to `~> 1.5`, `autoprefixer-rails` to `>= 10.0`
2. Run:
   ```bash
   bundle update
   bundle exec rails app:update
   bundle exec rails zeitwerk:check
   ```
3. In **production.rb**, switch JS compressor to terser (Config agent can do in Phase C if not done here): e.g. `config.assets.js_compressor = :terser` and remove `uglifier`.
4. Commit: `git add -A && git commit -m "Upgrade to Ruby 3.4.7 and Rails 7.2.2"`
5. **QA:** Local full pass with **cursor-ide-browser**.

---

## Phase C) Production boot and runtime fixes (Config agent)

**Must-do before first production deploy.**

1. **Remove legacy encrypted secrets**
   - File: `config/environments/production.rb`
   - Remove or comment: `config.read_encrypted_secrets = true`
   - App already uses unencrypted `config/secrets.yml` with `ENV["SECRET_KEY_BASE"]` in production.

2. **ActionCable Redis**
   - File: `config/cable.yml`
   - Production section:
     ```yaml
     production:
       adapter: redis
       url: <%= ENV.fetch("REDIS_URL") %>
       channel_prefix: tomtrago_production
     ```

3. **Asset compressor (Rails 7)**
   - In `config/environments/production.rb`, set:
     ```ruby
     config.assets.js_compressor = :terser
     ```
   - Ensure `uglifier` is removed from Gemfile and `terser` is present.

4. **Optional: Sidekiq worker `continue` bug**
   - If you later add Sidekiq and a worker uses `continue`, replace with `next` (Ruby doesn’t have `continue`). No change needed for current tomtrago.com.

Commit: `git add -A && git commit -m "Fix production config: secrets + Redis + assets"`

---

## Phase D) Heroku (Deploy agent)

Replace `<APP_NAME>` with your Heroku app name.

1. **Stack**
   ```bash
   heroku stack:set heroku-24 -a <APP_NAME>
   ```

2. **Buildpacks** (Node for asset pipeline, then Ruby)
   ```bash
   heroku buildpacks:clear -a <APP_NAME>
   heroku buildpacks:add heroku/nodejs -a <APP_NAME>
   heroku buildpacks:add heroku/ruby -a <APP_NAME>
   ```

3. **Redis** (for ActionCable)
   ```bash
   heroku addons:create heroku-redis -a <APP_NAME>
   ```

4. **Config vars**
   ```bash
   heroku config:set RAILS_ENV=production -a <APP_NAME>
   heroku config:set RAILS_SERVE_STATIC_FILES=1 -a <APP_NAME>
   heroku config:set RAILS_LOG_TO_STDOUT=1 -a <APP_NAME>
   heroku config:set SECRET_KEY_BASE=$(bundle exec rails secret) -a <APP_NAME>
   ```
   `REDIS_URL` is set automatically when you add Heroku Redis.

5. **Deploy**
   ```bash
   git push heroku upgrade-ruby-rails-heroku:main
   heroku run rails db:migrate -a <APP_NAME>
   heroku logs --tail -a <APP_NAME>
   ```

---

## Phase E) Verify (QA agent + cursor-ide-browser)

1. **Browser MCP:** Navigate to `https://<APP_NAME>.herokuapp.com`.
2. Snapshot; confirm:
   - HTTP 200, no boot error page.
   - CSS/JS assets load (no 404 for application.css/application.js).
   - No critical console errors.
3. If ActionCable is in use, verify WebSocket or channel behavior.
4. If something fails, use **Phase F** checklist.

---

## Phase F) Common failure fixes

| Symptom | Checks |
|--------|--------|
| Asset compile errors | `terser` in Gemfile, `uglifier` removed; Node buildpack first. |
| Redis / Cable errors | `REDIS_URL` in Heroku config; `config/cable.yml` production uses `ENV.fetch("REDIS_URL")`. |
| Boot error (secrets) | `config.read_encrypted_secrets = true` removed in production.rb. |
| Zeitwerk / autoload | Run `bundle exec rails zeitwerk:check`; fix constant/file naming. |
| Devise / other gems | Run `bundle exec rails app:update`, merge initializers carefully; bump gem versions per Rails 7 compatibility. |

---

## Execution order summary

1. **A** – Branch + optional baseline boot/browser check.
2. **B** – Stage 1 (5.2) → commit → optional QA.
3. **B** – Stage 2 (Ruby 3.2, Rails 6.1) → commit → optional QA.
4. **B** – Stage 3 (Ruby 3.4.7, Rails 7.2.2) → commit → QA.
5. **C** – Production config fixes → commit.
6. **D** – Heroku stack, buildpacks, Redis, config, deploy, migrate.
7. **E** – Browser MCP verification on production URL.
8. **F** – If needed, apply failure checklist and re-verify.

---

## Cursor “single prompt” usage

You can paste this plan (or the section you’re on) into Cursor and ask it to execute as the **Upgrade** or **Config** agent, specifying: “Use the user-filesystem MCP to read/write the following files…” and “After edits, run these terminal commands…”. For QA steps, ask: “Use the cursor-ide-browser MCP to open this URL and verify the page loads and assets don’t 404.”

This gives you a single reference plan that supports multiple agents and all available MCP tools (browser, filesystem, gateway) while staying aligned with your staged Rails/Ruby upgrade and Heroku targets.
