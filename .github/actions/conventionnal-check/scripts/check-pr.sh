#!/usr/bin/env bash

set -euo pipefail

DEFAULT_PR_REGEX="^(feat|fix|docs|chore|refactor|perf|test|build|ci|revert)($$[^$$]+\))?: .{1,72}$"

PR_REGEX="${PR_REGEX:-$DEFAULT_PR_REGEX}"

if [[ -f "${GITHUB_EVENT_PATH:-}" ]]; then
  PR_TITLE=$(jq -r .pull_request.title "$GITHUB_EVENT_PATH")
else
  echo "⚠️  Aucun payload d’événement disponible – la vérification du titre de PR sera ignorée."
  exit 0
fi

echo "🔎 Vérification du titre de la PR : \"$PR_TITLE\""

if [[ ! "$PR_TITLE" =~ $PR_REGEX ]]; then
  echo "❌ Le titre de la PR ne respecte pas la convention attendue."
  echo "   Regex attendu : $PR_REGEX"
  echo "   Exemple valide : feat(parser): add support for arrays"
  exit 1
fi

echo "✅ Le titre de la PR est conforme."
