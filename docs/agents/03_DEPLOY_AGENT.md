# Window 3 — Deploy Agent

**You are the Deploy agent.** You run **Heroku CLI only**; you do not edit repo files. Do not run `bundle` or change Gemfile or config files.

**Contract:** [PARALLEL_DEV_CONTRACT.md](../PARALLEL_DEV_CONTRACT.md) — you own the push and Heroku commands. Run **only after** Config agent has committed Phase C.

---

## Risk (read before starting)

- **Wrong app:** Replace `<APP_NAME>` with the real Heroku app name. Pushing to the wrong app can affect production.
- **Redis:** If Heroku Redis is not attached, `REDIS_URL` will be missing and ActionCable/production may fail. Ensure add-on is created and config is set.

---

## Pre-flight

- [ ] Config agent has completed Phase C and committed.
- [ ] Branch `upgrade-ruby-rails-heroku` is the one you will push.
- [ ] You have Heroku CLI installed and are logged in (`heroku auth:whoami`).
- [ ] Replace every `<APP_NAME>` below with your app name.

---

## Phase D — Heroku

### 1) Stack

- [ ] `heroku stack:set heroku-24 -a <APP_NAME>`

### 2) Buildpacks (Node then Ruby)

- [ ] `heroku buildpacks:clear -a <APP_NAME>`
- [ ] `heroku buildpacks:add heroku/nodejs -a <APP_NAME>`
- [ ] `heroku buildpacks:add heroku/ruby -a <APP_NAME>`

### 3) Redis (for ActionCable)

- [ ] `heroku addons:create heroku-redis -a <APP_NAME>`  
  (Skip if already added; this sets `REDIS_URL` automatically.)

### 4) Config vars

- [ ] `heroku config:set RAILS_ENV=production -a <APP_NAME>`
- [ ] `heroku config:set RAILS_SERVE_STATIC_FILES=1 -a <APP_NAME>`
- [ ] `heroku config:set RAILS_LOG_TO_STDOUT=1 -a <APP_NAME>`
- [ ] `heroku config:set SECRET_KEY_BASE=$(cd /Users/air/tomtrago.com && bundle exec rails secret) -a <APP_NAME>`

### 5) Deploy and migrate

- [ ] `cd /Users/air/tomtrago.com`
- [ ] `git push heroku upgrade-ruby-rails-heroku:main`
- [ ] `heroku run rails db:migrate -a <APP_NAME>`
- [ ] `heroku logs --tail -a <APP_NAME>` — confirm web dyno boots with no secrets/Redis error.
- [ ] **Handoff:** Tell **QA agent (Window 4)** the production URL (e.g. `https://<APP_NAME>.herokuapp.com`) and to run Phase E.

---

## Done (Deploy agent)

After push, migrate, and logs check, your work is complete. QA will verify the site and assets in the browser.
