# Window 2 — Config Agent

**You are the Config agent.** You are the **only** agent that edits `config/environments/production.rb` and `config/cable.yml` in Phase C. Do not edit `Gemfile` or run `bundle` or `rails app:update`.

**Contract:** [PARALLEL_DEV_CONTRACT.md](../PARALLEL_DEV_CONTRACT.md) — you own production.rb and cable.yml during C. Run **only after** Upgrade agent has finished Stage 3 (B3) and committed.

---

## Risk (read before starting)

- **Wrong order:** If you run before Upgrade finishes B3, your edits might be overwritten by `rails app:update` or conflict with Gemfile changes. Start only when Upgrade hands off to you.
- **Secrets:** Removing `config.read_encrypted_secrets = true` is required for Heroku; the app already uses `ENV["SECRET_KEY_BASE"]` in secrets.yml for production.

---

## Pre-flight

- [ ] Upgrade agent has completed Stage 3 (B3) and committed.
- [ ] Branch is `upgrade-ruby-rails-heroku`.
- [ ] `git status` is clean or only shows your intended edits.

---

## Phase C — Production boot and runtime fixes

### 1) Remove legacy encrypted secrets

- [ ] Open `config/environments/production.rb`.
- [ ] Remove or comment out the line: `config.read_encrypted_secrets = true`
- [ ] Save.

### 2) ActionCable Redis (production)

- [ ] Open `config/cable.yml`.
- [ ] In the `production:` section, set:
  ```yaml
  production:
    adapter: redis
    url: <%= ENV.fetch("REDIS_URL") %>
    channel_prefix: tomtrago_production
  ```
- [ ] Remove any `url: redis://localhost:6379/1` (or similar).
- [ ] Save.

### 3) Asset compressor (Rails 7 / terser)

- [ ] In `config/environments/production.rb`, ensure the JS compressor is set for terser:
  ```ruby
  config.assets.js_compressor = :terser
  ```
- [ ] If you see `config.assets.js_compressor = :uglifier`, replace with the line above.
- [ ] Save.

### 4) Commit

- [ ] `git add config/environments/production.rb config/cable.yml`
- [ ] `git commit -m "Fix production config: secrets + Redis + assets"`
- [ ] **Handoff:** Tell **Deploy agent (Window 3)** to run Phase D. Tell **QA (Window 4)** to run production verification after deploy.

---

## Done (Config agent)

After commit, your work is complete. Deploy agent will set Heroku stack, buildpacks, Redis, config vars, and push.
