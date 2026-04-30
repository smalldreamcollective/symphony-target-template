#!/usr/bin/env bash
# setup.sh — prepare this repository for use with Symphony
#
# Creates the GitHub labels that Symphony uses to track issue state.
# Run this once after creating or forking the repo.
#
# Requirements: gh (GitHub CLI), authenticated with write access to this repo

set -euo pipefail

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null) || {
  echo "Error: could not determine repo. Run this from inside the cloned repo." >&2
  exit 1
}

echo "Setting up Symphony labels for $REPO..."

create_label() {
  local name="$1" color="$2" description="$3"
  if gh label list --repo "$REPO" --json name -q '.[].name' | grep -qx "$name"; then
    echo "  ✓ '$name' already exists — skipping"
  else
    gh label create "$name" --repo "$REPO" --color "$color" --description "$description"
    echo "  + created '$name'"
  fi
}

# Active state — issues with this label will be picked up by Symphony
create_label "ready"   "0075ca" "Ready for Symphony to work on"

# Terminal state — applied by the agent when work is complete
create_label "done"    "0e8a16" "Completed by Symphony"

# Cancel state — applied when a running agent is cancelled from the dashboard
create_label "wontfix" "e4e669" "Cancelled — Symphony will not process this issue"

echo ""
echo "Done. Next steps:"
echo "  1. Edit WORKFLOW.md — fill in the TODO values"
echo "  2. Create issues and apply the 'ready' label to queue them"
echo "  3. Start Symphony: ./start.sh --workflow \$(pwd)/WORKFLOW.md --port 4000"
