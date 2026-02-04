#!/usr/bin/env bash
# Generate Gemfile.lock using Ruby 3.4 in Docker. No need to install Ruby locally.
# Requires: Docker Desktop running.
# Usage: ./scripts/docker-generate-lock.sh

set -e
cd "$(dirname "$0")/.."

echo "=== Generating Gemfile.lock in Ruby 3.4 container ==="
docker run --rm -v "$(pwd)":/app -w /app ruby:3.4-slim bash -c "
  apt-get update -qq && apt-get install -y -qq build-essential libpq-dev nodejs > /dev/null
  bundle install
"

echo ""
echo "=== Done. Next: commit and push ==="
echo "  git add Gemfile.lock"
echo "  git commit -m \"Add Gemfile.lock for Ruby 3.4\""
echo "  git push origin development"
echo ""
