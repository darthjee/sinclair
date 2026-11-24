#!/usr/bin/env bash
# Usage: scripts/bump_version.sh [major|minor|patch|X.Y.Z]
# Without arguments, bumps the patch version of the current version.

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
README="$ROOT/README.md"
VERSION_FILE="$ROOT/lib/sinclair/version.rb"
LOCKFILE="$ROOT/Gemfile.lock"
GEM="sinclair"

current=$(grep -oE "VERSION = '[0-9]+\.[0-9]+\.[0-9]+'" "$VERSION_FILE" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
IFS='.' read -r cmajor cminor cpatch <<< "$current"

arg="${1:-patch}"

case "$arg" in
  major) new_version="$((cmajor + 1)).0.0" ;;
  minor) new_version="${cmajor}.$((cminor + 1)).0" ;;
  patch) new_version="${cmajor}.${cminor}.$((cpatch + 1))" ;;
  *) new_version="$arg" ;;
esac

# Validate semver format
if ! echo "$new_version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "Error: version must be major, minor, patch or X.Y.Z" >&2
  exit 1
fi

# Next release: following minor
IFS='.' read -r major minor _patch <<< "$new_version"
next_release="${major}.$((minor + 1)).0"

echo "Current version: $current"
echo "New version:     $new_version"
echo "Next release:    $next_release"

# version.rb
sed -i '' "s|VERSION = '[0-9.]*'|VERSION = '${new_version}'|" "$VERSION_FILE"

# README: YARD docs link
sed -i '' \
  "s|rubydoc.info/gems/${GEM}/[0-9.]*|rubydoc.info/gems/${GEM}/${new_version}|g" \
  "$README"

# README: Current Release line
sed -i '' \
  "s|\*\*Current Release\*\*: \[[0-9.]*\](https://github.com/darthjee/sinclair/tree/[0-9.]*)|**Current Release**: [${new_version}](https://github.com/darthjee/sinclair/tree/${new_version})|" \
  "$README"

# README: Next release line
sed -i '' \
  "s|\*\*Next release\*\*: \[[0-9.]*\](https://github.com/darthjee/sinclair/compare/[0-9.]*\.\.\.main)|**Next release**: [${next_release}](https://github.com/darthjee/sinclair/compare/${new_version}...main)|" \
  "$README"

# Gemfile.lock
if [ -f "$LOCKFILE" ]; then
  sed -i '' "s|^\( *${GEM} (\)[0-9.]*)|\1${new_version})|" "$LOCKFILE"
fi

echo "Done."
