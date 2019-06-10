#!/bin/bash

DIFF_LIST=$(git diff --name-only $CIRCLE_SHA1 $(git merge-base $CIRCLE_SHA1 origin/master) | grep "^lib/")

if [ ! -z "$DIFF_LIST" ]; then
  mkdir -p tmp/rubycritic/compare
  bundle exec rubycritic --format console --branch origin/master -t 0 $DIFF_LIST
else
  echo "No changes detected. Skipping rubycritic..."
fi
