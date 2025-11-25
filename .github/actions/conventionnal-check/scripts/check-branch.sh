#!/usr/bin/env bash
set -euo pipefail

# Get the current branch name (works for pushes and PRs)
BRANCH_NAME="${GITHUB_REF#refs/heads/}"
BRANCH_NAME="${BRANCH_NAME#refs/pull/}"   # PR refs look like refs/pull/<id>/merge

echo "🔎 Checking branch name: $BRANCH_NAME"

if [[ ! "$BRANCH_NAME" =~ $BRANCH_REGEX ]]; then
  echo "❌ Branch name does NOT match the required pattern."
  echo "   Expected pattern: $BRANCH_REGEX"
  echo "   Example: feature/1234-add-login-page"
  exit 1
fi

echo "✅ Branch name conforms."
