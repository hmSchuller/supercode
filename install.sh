#!/usr/bin/env bash
set -euo pipefail

MARKER="# supercode opencode profile"
DIR="${SUPERCODE_DIR:-$HOME/.config/supercode}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_REPO="https://github.com/hmSchuller/supercode.git"
REPO="${SUPERCODE_REPO:-}"

pick_shell_rc() {
  if [[ -n "${SHELL_RC:-}" ]]; then
    echo "$SHELL_RC"
  elif [[ -f "$HOME/.zshrc" ]]; then
    echo "$HOME/.zshrc"
  elif [[ -f "$HOME/.bashrc" ]]; then
    echo "$HOME/.bashrc"
  else
    echo "$HOME/.profile"
  fi
}

install_from_dir() {
  local src="$1"
  mkdir -p "$(dirname "$DIR")"

  if [[ "$(cd "$src" && pwd)" == "$(cd "$DIR" 2>/dev/null && pwd)" ]]; then
    echo "Source and install dir are the same: $DIR"
    return
  fi

  if command -v rsync >/dev/null 2>&1; then
    mkdir -p "$DIR"
    rsync -a --delete \
      --exclude .git \
      --exclude .DS_Store \
      "$src/" "$DIR/"
  else
    rm -rf "$DIR"
    cp -R "$src" "$DIR"
  fi

  echo "Installed profile to $DIR"
}

if [[ -n "$REPO" ]]; then
  if [[ -d "$REPO" ]]; then
    install_from_dir "$(cd "$REPO" && pwd)"
  else
    if [[ -d "$DIR/.git" ]]; then
      git -C "$DIR" pull --ff-only
      echo "Updated $DIR"
    else
      git clone "$REPO" "$DIR"
      echo "Cloned to $DIR"
    fi
  fi
elif [[ -f "$SCRIPT_DIR/opencode.jsonc" ]]; then
  install_from_dir "$SCRIPT_DIR"
else
  if [[ -d "$DIR/.git" ]]; then
    git -C "$DIR" pull --ff-only
    echo "Updated $DIR"
  else
    git clone "$DEFAULT_REPO" "$DIR"
    echo "Cloned to $DIR"
  fi
fi

SHELL_RC="$(pick_shell_rc)"

add_supercode_function() {
  cat <<'EOF'
supercode() {
  OPENCODE_CONFIG="$HOME/.config/supercode/opencode.jsonc" \
  OPENCODE_CONFIG_DIR="$HOME/.config/supercode" \
  command opencode "$@"
}
EOF
}

configure_shell_rc() {
  local rc="$1"

  if grep -q "supercode()" "$rc" 2>/dev/null; then
    echo "Shell profile already configured ($rc)"
    return
  fi

  if grep -q "$MARKER" "$rc" 2>/dev/null; then
    local tmp inserted=0
    tmp="$(mktemp)"
    while IFS= read -r line || [[ -n "$line" ]]; do
      if [[ "$line" == 'export OPENCODE_CONFIG="$HOME/.config/supercode/opencode.jsonc"' ]]; then
        continue
      fi
      if [[ "$line" == 'export OPENCODE_CONFIG_DIR="$HOME/.config/supercode"' ]]; then
        continue
      fi
      echo "$line" >>"$tmp"
      if [[ "$line" == "$MARKER" && "$inserted" -eq 0 ]]; then
        add_supercode_function >>"$tmp"
        inserted=1
      fi
    done <"$rc"
    mv "$tmp" "$rc"
    echo "Upgraded shell profile in $rc"
    return
  fi

  {
    echo ""
    echo "$MARKER"
    add_supercode_function
  } >>"$rc"
  echo "Added supercode command to $rc"
}

configure_shell_rc "$SHELL_RC"

cat <<EOF

Supercode installed.

Next steps:
  1. source "$SHELL_RC"
  2. Copy .env.example values into your shell profile if needed
  3. supercode auth
  4. supercode

To update later:
  cd "$DIR" && git pull

To uninstall:
  remove the "$MARKER" block from $SHELL_RC
  rm -rf "$DIR"
EOF
