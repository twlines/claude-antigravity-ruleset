#!/usr/bin/env bash
set -euo pipefail

# ─── New Project Setup Script ──────────────────────────────────────
# Copies the starter kit into a project directory.
# Files are COPIED (not symlinked) so they can be customized per project.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTER_KIT="$SCRIPT_DIR/project-starter-kit"

if [[ $# -lt 1 ]]; then
  echo "Usage: ./new-project.sh /path/to/project"
  echo ""
  echo "Copies the starter kit files into the target project directory."
  echo "Existing files will NOT be overwritten."
  exit 1
fi

TARGET_DIR="$1"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "❌ Directory does not exist: $TARGET_DIR"
  echo "   Create it first, then re-run this script."
  exit 1
fi

echo "📦 Copying starter kit to: $TARGET_DIR"
echo ""

# Track what we create
CREATED=0
SKIPPED=0

copy_if_missing() {
  local source="$1"
  local relative="${source#$STARTER_KIT/}"
  local target="$TARGET_DIR/$relative"
  local target_dir
  target_dir="$(dirname "$target")"

  mkdir -p "$target_dir"

  if [[ -f "$target" ]]; then
    echo "  ⏭  Skipped (exists): $relative"
    SKIPPED=$((SKIPPED + 1))
  else
    cp "$source" "$target"
    echo "  ✅ Created: $relative"
    CREATED=$((CREATED + 1))
  fi
}

# Copy all files from starter kit
while IFS= read -r -d '' file; do
  copy_if_missing "$file"
done < <(find "$STARTER_KIT" -type f -print0)

echo ""
echo "Done! Created $CREATED files, skipped $SKIPPED existing files."
echo ""

if [[ $CREATED -gt 0 ]]; then
  echo "⚠️  Next steps:"
  echo "  1. Search for [CUSTOMIZE] markers and adapt to your project"
  echo "  2. Update CLAUDE.md with your project's tech stack and commands"
  echo "  3. Update .agent/workflows/verify.md with your build/test commands"
  echo "  4. Commit the new files to your project's repo"
fi
