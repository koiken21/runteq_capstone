#!/bin/bash

# This script installs Ruby 3.3.6 using rbenv if it is not already installed,
# installs project dependencies with Bundler, and runs the test suite.
# It is safe to run multiple times.

set -euo pipefail

RUBY_VERSION="3.3.6"

# Function: install packages required for building Ruby
install_packages() {
  sudo apt-get update
  sudo apt-get install -y git build-essential libssl-dev libreadline-dev zlib1g-dev \
    autoconf bison libyaml-dev libgdbm-dev libdb-dev libncurses5-dev libffi-dev \
    libgmp-dev
}

# Function: install rbenv and ruby-build
install_rbenv() {
  if [ ! -d "$HOME/.rbenv" ]; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    cd ~/.rbenv && src/configure && make -C src
    cd - >/dev/null
  fi
  export PATH="$HOME/.rbenv/bin:$PATH"
  if ! grep -q 'rbenv init' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'eval "$(rbenv init -)"' >> "$HOME/.bashrc"
  fi
  eval "$(rbenv init -)"

  if [ ! -d "$HOME/.rbenv/plugins/ruby-build" ]; then
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  fi
}

# Function: install specified Ruby version
install_ruby() {
  if ! rbenv versions --bare | grep -q "^${RUBY_VERSION}$"; then
    rbenv install "$RUBY_VERSION"
  fi
  rbenv local "$RUBY_VERSION"
}

# Function: install bundler and project gems
install_bundler() {
  if ! gem list bundler -i >/dev/null; then
    gem install bundler --no-document
  fi
  if ! bundle check >/dev/null 2>&1; then
    bundle install
  fi
}

main() {
  if ! ruby -v 2>/dev/null | grep -q "${RUBY_VERSION}"; then
    install_packages
    install_rbenv
    install_ruby
  else
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    rbenv local "$RUBY_VERSION"
  fi

  install_bundler

  bundle exec rails test
}

main "$@"

