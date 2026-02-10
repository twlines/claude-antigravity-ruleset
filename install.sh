#!/usr/bin/env bash
set -euo pipefail

# ─── AI Rules Install Script ───────────────────────────────────────
# Creates symlinks from this repo to ~/.claude/ and ~/.gemini/
# Safe to re-run — backs up existing files before overwriting.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "🔧 Installing AI rules from: $SCRIPT_DIR"
echo ""

# ─── Helper ─────────────────────────────────────────────────────────

create_symlink() {
  local source="$1"
  local target="$2"
  local target_dir
  target_dir="$(dirname "$target")"

  # Ensure target directory exists
  mkdir -p "$target_dir"

  # Back up existing file (if it's a real file, not already a symlink)
  if [[ -f "$target" && ! -L "$target" ]]; then
    local backup="${target}.backup.${TIMESTAMP}"
    echo "  📦 Backing up existing: $target → $backup"
    mv "$target" "$backup"
  fi

  # Remove existing symlink if pointing elsewhere
  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      echo "  ✅ Already linked: $target"
      return 0
    else
      echo "  🔄 Updating symlink: $target"
      rm "$target"
    fi
  fi

  ln -s "$source" "$target"
  echo "  🔗 Linked: $target → $source"
}

# ─── Claude Code ────────────────────────────────────────────────────

echo "📎 Claude Code (~/.claude/)"

create_symlink \
  "$SCRIPT_DIR/global/engineering-rules.md" \
  "$HOME/.claude/build-it-right-rules.md"

create_symlink \
  "$SCRIPT_DIR/project-starter-kit" \
  "$HOME/.claude/project-starter-kit"

echo ""

# ─── Antigravity ────────────────────────────────────────────────────

echo "🌀 Antigravity (~/.gemini/)"

create_symlink \
  "$SCRIPT_DIR/global/gemini-global.md" \
  "$HOME/.gemini/GEMINI.md"

# Also link engineering-rules.md so GEMINI.md's relative reference works
create_symlink \
  "$SCRIPT_DIR/global/engineering-rules.md" \
  "$HOME/.gemini/engineering-rules.md"

echo ""

# ─── Summary ────────────────────────────────────────────────────────

echo "✅ Install complete!"
echo ""
echo "Symlinks created:"
echo "  ~/.claude/build-it-right-rules.md  → global/engineering-rules.md"
echo "  ~/.claude/project-starter-kit/     → project-starter-kit/"
echo "  ~/.gemini/GEMINI.md                → global/gemini-global.md"
echo "  ~/.gemini/engineering-rules.md     → global/engineering-rules.md"
echo ""
echo "To update rules on any machine:"
echo "  cd ~/ai-rules && git pull"
echo ""
echo "To start a new project:"
echo "  ./new-project.sh /path/to/project"
