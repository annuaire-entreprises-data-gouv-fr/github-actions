#!/usr/bin/env bash
set -euo pipefail

# Determine the range of new commits.
# For a push event we can use $GITHUB_SHA and $GITHUB_BASE_REF.
# For a PR we use the diff against the target branch.
if [[ "${GITHUB_EVENT_NAME}" == "pull_request" ]]; then
  RANGE="$BASE_COMMIT..${GITHUB_SHA}"
else
  # In a push event, GITHUB_BEFORE is the previous HEAD.
  RANGE="${GITHUB_BEFORE}..${GITHUB_SHA}"
fi

echo "🔎 Checking commit messages in range: $RANGE"

# Loop over each new commit
git rev-list --reverse "$RANGE" | while read -r COMMIT; do
  MSG=$(git log -1 --pretty=%B "$COMMIT")
  FIRST_LINE=$(echo "$MSG" | head -n1)

  if [[ ! "$FIRST_LINE" =~ $REGEX ]]; then
    echo "❌ Commit $COMMIT does NOT follow Conventional Commits."
    echo "   Message: $FIRST_LINE"
    echo "   Expected pattern: <type>(<scope>)?: <subject>"
    exit 1
  fi
done

echo "✅ All commit messages conform."
