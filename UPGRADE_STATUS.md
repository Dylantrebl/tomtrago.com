# Upgrade status

**Branch:** `upgrade-ruby-rails-heroku`  
**Target:** Ruby 3.4.7, Rails 7.2.2, Heroku heroku-24

## Done (in repo)

- [x] Gemfile updated to Ruby 3.4.7, Rails 7.2.2, Puma 6.4, pg ~> 1.5, sassc-rails, terser (sass-rails and uglifier removed).
- [x] Production config: `config.read_encrypted_secrets` removed; `config.assets.js_compressor = :terser`.
- [x] `config/cable.yml` production uses `ENV.fetch("REDIS_URL")`.
- [x] `config/application.rb` set to `config.load_defaults 7.2`.
- [x] `.ruby-version` set to 3.4.7.

## You need to run (Ruby 3.4 required)

1. **Install Ruby 3.4.7** (e.g. `rbenv install 3.4.7 && rbenv local 3.4.7`).
2. **Run:** `./bin/upgrade-post-install` (bundle, app:update, zeitwerk:check).
3. **Test:** `bundle exec rails s` and open http://localhost:3000.
4. **Deploy (when ready):** `./bin/heroku-deploy-upgrade YOUR_APP_NAME`.

Full details: **[docs/RUN_AFTER_UPGRADE.md](docs/RUN_AFTER_UPGRADE.md)**.

**Why:** Automated `bundle install` failed in this environment (system Ruby 2.6; native gem build failure). All source and config changes are committed; running the steps in the doc with Ruby 3.4 completes the upgrade.

**Test deploy (Heroku app `tomtragodotcomm`):** See **[docs/TEST_DEPLOY_TOMTRAGODOTCOMM.md](docs/TEST_DEPLOY_TOMTRAGODOTCOMM.md)**. Branch `upgrade-ruby-rails-heroku` is on GitHub; deploy from Dashboard (branch = upgrade-ruby-rails-heroku) or run `./bin/heroku-deploy-upgrade tomtragodotcomm` locally.
