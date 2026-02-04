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

See **[docs/RUN_AFTER_UPGRADE.md](docs/RUN_AFTER_UPGRADE.md)** for:

1. `bundle install` and `rails app:update` (with Ruby 3.4.7).
2. Local smoke test.
3. Heroku stack, buildpacks, Redis, config, and deploy.

**Why:** Automated `bundle install` failed in this environment (system Ruby 2.6; native gem build failure). All source and config changes are committed; running the steps in the doc with Ruby 3.4 completes the upgrade.
