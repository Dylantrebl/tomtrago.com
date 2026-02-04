# Run after upgrade (when Ruby 3.4 is available)

All **file changes** for the Rails 5.1 → 7.2 / Ruby 2.5 → 3.4.7 upgrade are already applied on branch `upgrade-ruby-rails-heroku`. The only remaining steps require a working **Ruby 3.4** (e.g. `rbenv install 3.4.7` or Heroku’s Ruby 3.4).

---

## 1. Install Ruby 3.4.7 (if needed)

```bash
# rbenv
rbenv install 3.4.7
rbenv local 3.4.7

# or rvm
rvm install 3.4.7
rvm use 3.4.7
```

---

## 2. Bundle and Rails

```bash
cd /Users/air/tomtrago.com
rm -f Gemfile.lock
bundle install
bundle exec rails app:update
# Resolve any config conflicts; keep app-specific settings.
bundle exec rails zeitwerk:check
```

---

## 3. Boot and test locally

```bash
bundle exec rails s
# Open http://localhost:3000 and confirm assets and page load.
```

---

## 4. Heroku (when ready)

Replace `<APP_NAME>` with your Heroku app name.

```bash
heroku stack:set heroku-24 -a <APP_NAME>
heroku buildpacks:clear -a <APP_NAME>
heroku buildpacks:add heroku/nodejs -a <APP_NAME>
heroku buildpacks:add heroku/ruby -a <APP_NAME>
heroku addons:create heroku-redis -a <APP_NAME>   # if not already added
heroku config:set RAILS_ENV=production -a <APP_NAME>
heroku config:set RAILS_SERVE_STATIC_FILES=1 -a <APP_NAME>
heroku config:set RAILS_LOG_TO_STDOUT=1 -a <APP_NAME>
heroku config:set SECRET_KEY_BASE=$(bundle exec rails secret) -a <APP_NAME>
git push heroku upgrade-ruby-rails-heroku:main
heroku run rails db:migrate -a <APP_NAME>
heroku logs --tail -a <APP_NAME>
```

---

## Why these steps weren’t run automatically

- **Bundle / Rails:** Your current environment uses system Ruby 2.6; building native gems (e.g. `racc`) failed, and the upgrade targets Ruby 3.4.7. Running `bundle install` and `rails app:update` with Ruby 3.4 (locally or on Heroku) will complete the upgrade.
- **Heroku:** Deploy and config require your Heroku app name and auth; run the commands above when you’re ready to deploy.
