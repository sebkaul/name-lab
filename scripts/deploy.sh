#!/usr/bin/env bash
# Pull the latest commit, fetch the fonts, and publish the site to the web root.
# Usage: scripts/deploy.sh            (WEBROOT defaults to /srv/http/namelab)
#        WEBROOT=/var/www/namelab scripts/deploy.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEBROOT="${WEBROOT:-/srv/http/namelab}"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

cd "$REPO_DIR"

echo ">>> Updating repo"
git pull --ff-only

echo ">>> Fetching fonts"
scripts/fetch-fonts.sh
# fetch-fonts.sh skips fonts it can't get, so make sure we have some at all
compgen -G "fonts/*.ttf" >/dev/null || { echo "no fonts in fonts/, aborting" >&2; exit 1; }

# Stage first, so a failure never leaves the live site half-updated.
cp index.html fonts.html "$STAGE/"
cp -r fonts "$STAGE/fonts"

echo ">>> Publishing to $WEBROOT"
mkdir -p "$WEBROOT"
rsync -a --delete "$STAGE/" "$WEBROOT/"

echo ">>> Done"
