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

## 2. Run the post-install script (bundle + rails app:update + zeitwerk)

```bash
cd /Users/air/tomtrago.com
./bin/upgrade-post-install
```

This script checks Ruby 3.4, removes `Gemfile.lock`, runs `bundle install`, `rails app:update`, and `rails zeitwerk:check`. Resolve any config conflicts when prompted; keep app-specific settings.

**Manual equivalent:**

```bash
rm -f Gemfile.lock
bundle install
bundle exec rails app:update
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

**One command (replace `YOUR_APP_NAME` with your Heroku app name):**

```bash
./bin/heroku-deploy-upgrade YOUR_APP_NAME
```

This sets stack, buildpacks, Redis (if missing), config vars, pushes the upgrade branch, runs migrations, and tails logs.

**Manual equivalent:** see the script source in `bin/heroku-deploy-upgrade` for the full command list.

---

## Why these steps weren’t run automatically

- **Bundle / Rails:** Your current environment uses system Ruby 2.6; building native gems (e.g. `racc`) failed, and the upgrade targets Ruby 3.4.7. Running `bundle install` and `rails app:update` with Ruby 3.4 (locally or on Heroku) will complete the upgrade.
- **Heroku:** Deploy and config require your Heroku app name and auth; run the commands above when you’re ready to deploy.
