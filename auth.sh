#!/usr/bin/env bash
set -e

# Prompt for PAT without echoing input
read -rsp "Enter Personal Access Token (PAT): " PAT
echo

if [ -z "$PAT" ]; then
  echo "Error: PAT cannot be empty." >&2
  exit 1
fi

NPMRC="$HOME/.npmrc"

touch "$NPMRC"

if grep -q '_authToken=' "$NPMRC"; then
  # Update all existing _authToken entries
  sed -i "s|_authToken=.*|_authToken=$PAT|g" "$NPMRC"
  echo "Updated _authToken entries in $NPMRC"
else
  echo "Warning: No _authToken entries found in $NPMRC" >&2
  echo "Add your registry lines to $NPMRC first, e.g.:" >&2
  echo "  //pkgs.dev.azure.com/ORG/_packaging/FEED/npm/registry/:_authToken=" >&2
  echo "  //pkgs.dev.azure.com/ORG/_packaging/FEED/npm/:_authToken=" >&2
  exit 1
fi
