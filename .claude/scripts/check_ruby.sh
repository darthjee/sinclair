#!/usr/bin/env bash
set -euo pipefail
set -x

bundle exec rspec
rubocop
bundle exec rake verify_measurements
