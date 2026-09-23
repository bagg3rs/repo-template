#!/usr/bin/env bash
# check-issue-refs: fail when a commit cites no issue.
#
# CONTRIBUTING tells you to create an issue and then never asks you to reference
# it, which makes the issue graph unreliable exactly when you need it: months
# later, reading a confusing line of code and wanting the argument behind it. A
# closed issue keeps the reasoning and the alternatives that were rejected. A
# commit citing no issue is a dead end.
#
# This is a gate rather than a line in a doc because the convention decays
# without one. Measured on a repo that documented the rule and never checked it,
# the citation rate fell 78% -> 71% -> 64% over a quarter, with an agent writing
# most of the commits. Documentation alone does not hold a habit.
#
# It matters more here than in most repos: CI auto-merges a green PR, so nothing
# human reads these commit messages before they are permanent.
#
# Deliberately dumb about WHICH issue - it checks that a number is cited, not
# that the number is apt. A gate that judged relevance would be wrong often
# enough to get switched off, and switched-off gates are how conventions rot.
#
# It does NOT want a closing keyword everywhere. `Fixes`/`Closes` straight
# before a number is live wherever GitHub reads it, including in a sentence
# merely describing history, which silently closes issues that are still open.
# A bare `#12` or `Refs #12` satisfies this check.
#
# Escape hatches, narrow on purpose:
#   - merge commits are skipped (the subject is generated, not authored)
#   - dependency bumps are skipped: gitmoji `:package:` / the 📦 character, and
#     dependabot's `chore(deps)` form
#   - a line STARTING with `[no-issue]` skips that commit
#
# The marker must start a line, and that is not fussiness. A substring match
# anywhere in the message means a commit *describing* the escape hatch trips it -
# which is precisely what happened on this script's own first commit, and it is
# the third time in this family of repos that documentation became an
# instruction (`[skip ci]` in a line explaining `[skip ci]`, then a closing
# keyword in a sentence narrating a close). Prose mentions the marker
# mid-sentence; a trailer starts a line.
#
# Usage: ./scripts/check-issue-refs.sh [base-ref]
#   base-ref defaults to origin/main. CI passes the PR base.
#   Needs full history: actions/checkout with fetch-depth 0.
set -euo pipefail
cd "$(dirname "$0")/.."

BASE="${1:-origin/main}"

git rev-parse --verify --quiet "$BASE" >/dev/null || {
  echo "check-issue-refs: base ref '$BASE' not found"
  echo "  in CI this means the checkout was shallow - set fetch-depth: 0"
  exit 1
}

COMMITS=$(git rev-list --no-merges "$BASE..HEAD")

if [ -z "$COMMITS" ]; then
  echo "ok     no commits in $BASE..HEAD to check"
  exit 0
fi

checked=0
skipped=0
bad=""

for sha in $COMMITS; do
  subject=$(git log -1 --format=%s "$sha")
  message=$(git log -1 --format='%s%n%b' "$sha")

  case "$subject" in
    :package:*|📦*|chore\(deps\)*|chore\(deps-dev\)*)
      skipped=$((skipped + 1))
      continue
      ;;
  esac

  # Line-start, not substring: a commit describing the hatch must not trip it
  if printf '%s\n' "$message" | grep -qE '^\[no-issue\]'; then
    skipped=$((skipped + 1))
    continue
  fi

  checked=$((checked + 1))

  if ! printf '%s' "$message" | grep -qE '#[0-9]+'; then
    bad="$bad$(printf '\n  %.8s  %s' "$sha" "$subject")"
  fi
done

if [ -n "$bad" ]; then
  n=$(printf '%s' "$bad" | grep -c . || true)
  echo "FAIL   $n of $checked commits cite no issue:$bad"
  echo
  echo "Every piece of work ties to an issue (CONTRIBUTING.md). Amend the"
  echo "message to cite it - a bare '#12' or 'Refs #12' is enough. Keep a"
  echo "closing keyword away from the number unless you mean it to close."
  echo "Genuinely issueless? Start a line with [no-issue] and say why."
  exit 1
fi

echo "ok     $checked commits cite an issue${skipped:+ ($skipped skipped)}"
