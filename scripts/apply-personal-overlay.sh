#!/bin/bash
# Validate personal overlay integrity after rebasing onto upstream/dev.

set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
FAIL=0

pass() { echo -e "\e[32m✓\e[0m $1"; }
fail() { echo -e "\e[31m✗\e[0m $1"; FAIL=1; }

echo "Omarchy Personal overlay verification"
echo

MANIFEST="$ROOT/.personal-files"
if [[ ! -f $MANIFEST ]]; then
  echo "Missing .personal-files manifest" >&2
  exit 1
fi

while IFS= read -r path || [[ -n $path ]]; do
  [[ -z $path || $path =~ ^# ]] && continue
  if [[ -f $ROOT/$path || -d $ROOT/$path ]]; then
    pass "$path"
  else
    fail "Missing manifest path: $path"
  fi
done <"$MANIFEST"

HOOKS=(
  "install/preflight/all.sh:personal/preflight/all.sh"
  "install/post-install/all.sh:personal/post-install/all.sh"
  "install/config/all.sh:personal/config/all.sh"
  "install/packaging/base.sh:personal/packaging/base.sh"
  "install/packaging/all.sh:personal/packaging/all.sh"
)

for hook in "${HOOKS[@]}"; do
  file="${hook%%:*}"
  needle="${hook##*:}"
  if grep -q "$needle" "$ROOT/$file" 2>/dev/null; then
    pass "Hook in $file"
  else
    fail "Missing hook source in $file"
  fi
done

if git remote get-url upstream &>/dev/null; then
  pass "upstream remote present"
else
  fail "Add upstream: git remote add upstream git@github.com:basecamp/omarchy.git"
fi

echo
if (( FAIL == 0 )); then
  echo -e "\e[32mOverlay intact.\e[0m Rebase workflow:"
  echo "  git fetch upstream && git rebase upstream/dev"
  echo "  ./scripts/verify.sh"
else
  echo -e "\e[31mOverlay checks failed.\e[0m See PERSONAL.md and .personal-files"
  exit 1
fi
