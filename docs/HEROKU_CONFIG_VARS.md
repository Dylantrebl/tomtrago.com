# Heroku config vars — bring these across

All variables the app reads from the environment (from the **original repo** config) plus the one we generate for the new Rails 7 / Gemfile. Set these in **Heroku Dashboard → tomtragodotcomm → Settings → Config vars** (or via `heroku config:set`).

---

## Required (app won’t boot without these)

| Config var | Where it’s used | What to set |
|------------|------------------|-------------|
| **SECRET_KEY_BASE** | `config/secrets.yml` (production) | **Generate new** for Rails 7: run `cd /Users/air/tomtrago.com && bundle exec rails secret` and paste the value. Do not reuse old dev/test keys. |
| **DATABASE_URL** | `config/database.yml` | Set automatically when you add the **Heroku Postgres** add-on. If you don’t have Postgres, add it (Resources → Add-ons). |

---

## Recommended (Rails/Heroku best practice)

| Config var | Where it’s used | Value |
|------------|------------------|--------|
| **RAILS_ENV** | `config/puma.rb` | `production` |
| **RAILS_SERVE_STATIC_FILES** | `config/environments/production.rb` | `1` |
| **RAILS_LOG_TO_STDOUT** | `config/environments/production.rb` | `1` |

---

## Optional (have defaults or set by add-ons)

| Config var | Where it’s used | Notes |
|------------|------------------|--------|
| **REDIS_URL** | `config/cable.yml` | Set automatically when you add **Heroku Redis**. If you don’t add Redis, the app still builds (we use a default for precompile). |
| **RAILS_MAX_THREADS** | `config/puma.rb` | Default 5. Set only if you want to change it. |
| **DATABASE_POOL_SIZE** | `config/database.yml` | Default 15. Set only if you want to change it. |
| **PORT** | `config/puma.rb` | Set by Heroku; don’t set manually. |
| **MANUAL_DATABASE_URL** | `config/database.yml` | Only if you need to override `DATABASE_URL`. |

---

## One-time setup (copy-paste)

After Heroku Postgres is added (so `DATABASE_URL` exists), set the rest:

```bash
# Replace YOUR_APP with tomtragodotcomm if that’s your app name
APP=tomtragodotcomm

# Generate and set SECRET_KEY_BASE (new for Rails 7 / new Gemfile)
heroku config:set SECRET_KEY_BASE=$(cd /Users/air/tomtrago.com && bundle exec rails secret) -a $APP

# Recommended
heroku config:set RAILS_ENV=production -a $APP
heroku config:set RAILS_SERVE_STATIC_FILES=1 -a $APP
heroku config:set RAILS_LOG_TO_STDOUT=1 -a $APP
```

Then restart:

```bash
heroku restart -a $APP
```

---

## What’s *not* in the original repo

- No `.env` or `.env.example` was in the repo (it’s gitignored). The list above is taken only from `config/secrets.yml`, `config/database.yml`, `config/cable.yml`, `config/environments/production.rb`, and `config/puma.rb`.
- No CarrierWave/fog/S3 initializer or env vars in the codebase; if you add S3 uploads later, you’d add AWS (or fog) vars then.
- **SECRET_KEY_BASE** must be **new** for production with the new Gemfile/Rails 7—don’t reuse the development value from `config/secrets.yml`.
