#!/bin/zsh

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$REPO_ROOT" ]; then
  echo "Error: not inside a git repository."
  exit 1
fi

# Find files changed on this branch vs master
CHANGED_FILES=$(git diff master...HEAD --name-only 2>/dev/null)
if [ -z "$CHANGED_FILES" ]; then
  echo "No changes compared to master."
  exit 0
fi

# Extract unique package directories (packages/*, apps/*, tools/*)
CHANGED_PACKAGES=$(echo "$CHANGED_FILES" \
  | grep -E '^(packages|apps|tools)/' \
  | awk -F'/' '{print $1"/"$2}' \
  | sort -u)

if [ -z "$CHANGED_PACKAGES" ]; then
  echo "No package changes found compared to master."
  exit 0
fi

echo "Changed packages:"
echo "$CHANGED_PACKAGES" | sed 's/^/  /'
echo ""

FAILED=()

while IFS= read -r PACKAGE; do
  PACKAGE_PATH="$REPO_ROOT/$PACKAGE"

  if [ ! -f "$PACKAGE_PATH/package.json" ]; then
    echo "Skipping $PACKAGE (no package.json)"
    continue
  fi

  if ! grep -q '"lint"' "$PACKAGE_PATH/package.json"; then
    echo "Skipping $PACKAGE (no lint script)"
    continue
  fi

  echo "=========================================="
  echo "Linting: $PACKAGE"
  echo "=========================================="
  (cd "$PACKAGE_PATH" && yarn lint) || FAILED+=("$PACKAGE")
  echo ""
done <<< "$CHANGED_PACKAGES"

if [ ${#FAILED[@]} -gt 0 ]; then
  echo "=========================================="
  echo "LINT FAILED in:"
  for pkg in "${FAILED[@]}"; do
    echo "  - $pkg"
  done
  exit 1
else
  echo "All changed packages passed lint."
fi
