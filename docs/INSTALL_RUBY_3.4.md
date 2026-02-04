# Install Ruby 3.4.7 (so you can run `bundle install`)

Your Gemfile requires Ruby 3.4.7; you have 2.6.10. Install 3.4.7 with **rbenv** (recommended on macOS).

---

## Option A: rbenv (recommended)

**1. Install rbenv and ruby-build** (if you don’t have them):

```bash
brew install rbenv ruby-build
```

If you don’t use Homebrew, see: https://github.com/rbenv/rbenv#installation

**2. Add rbenv to your shell** (for zsh, add to `~/.zshrc`):

```bash
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc
```

**3. Install Ruby 3.4.7 and use it in this project:**

```bash
rbenv install 3.4.7
cd /Users/air/tomtrago.com
rbenv local 3.4.7
```

**4. Generate Gemfile.lock and push:**

```bash
bundle install
git add Gemfile.lock
git commit -m "Add Gemfile.lock for Ruby 3.4"
git push origin development
```

Then trigger a new Heroku deploy.

---

## Option B: RVM

```bash
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 3.4.7
cd /Users/air/tomtrago.com
rvm use 3.4.7
bundle install
# then git add, commit, push as above
```

---

## Option C: One-off with Docker (if you have Docker Desktop running)

```bash
cd /Users/air/tomtrago.com
docker run --rm -v "$(pwd)":/app -w /app ruby:3.4-slim bash -c "apt-get update -qq && apt-get install -y -qq build-essential libpq-dev nodejs > /dev/null && bundle install"
git add Gemfile.lock
git commit -m "Add Gemfile.lock for Ruby 3.4"
git push origin development
```

This runs `bundle install` inside a Ruby 3.4 container and writes `Gemfile.lock` into your project.

---

After any option, run `ruby -v` in the project directory and you should see `ruby 3.4.7`. Then `bundle install` will succeed.
