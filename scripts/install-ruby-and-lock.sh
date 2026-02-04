#!/usr/bin/env bash
# One-time: install Ruby 3.4.7 via Homebrew rbenv, then generate Gemfile.lock.
# Usage: ./scripts/install-ruby-and-lock.sh
# Run from project root: /Users/air/tomtrago.com

set -e
cd "$(dirname "$0")/.."

echo "=== Checking for rbenv ==="
if ! command -v rbenv &>/dev/null; then
  echo "Installing rbenv and ruby-build via Homebrew..."
  brew install rbenv ruby-build
  echo ""
  echo "Add rbenv to your shell (zsh). Run:"
  echo "  echo 'eval \"\$(rbenv init - zsh)\"' >> ~/.zshrc && source ~/.zshrc"
  echo ""
  echo "Then run this script again."
  exit 1
fi

echo "=== Initializing rbenv ==="
eval "$(rbenv init -)" 2>/dev/null || true

echo "=== Installing Ruby 3.4.7 (this may take a few minutes) ==="
rbenv install 3.4.7 --skip-existing 2>/dev/null || rbenv install 3.4.7

echo "=== Using Ruby 3.4.7 in this project ==="
rbenv local 3.4.7

echo "=== Generating Gemfile.lock ==="
bundle install

echo ""
echo "=== Done. Next: commit and push the lock ==="
echo "  git add Gemfile.lock"
echo "  git commit -m \"Add Gemfile.lock for Ruby 3.4\""
echo "  git push origin development"
echo ""
