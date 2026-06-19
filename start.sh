#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$HOME/.local/share/claude-code-telegram"
cd "$SCRIPT_DIR"

if [ ! -d "$SCRIPT_DIR/.venv" ]; then
  echo "missing venv: $SCRIPT_DIR/.venv" >&2
  exit 1
fi

if [ ! -f "$SCRIPT_DIR/.env" ]; then
  echo "missing env file: $SCRIPT_DIR/.env" >&2
  exit 1
fi

if [ ! -f "$HOME/.hermes/.env" ]; then
  echo "missing hermes env: $HOME/.hermes/.env" >&2
  exit 1
fi

source "$SCRIPT_DIR/.venv/bin/activate"

set -a
source "$SCRIPT_DIR/.env"
set +a

MINIMAX_CN_API_KEY_VALUE="$(grep '^MINIMAX_CN_API_KEY=' "$HOME/.hermes/.env" | head -1 | cut -d= -f2-)"
MINIMAX_CN_BASE_URL_VALUE="$(grep '^MINIMAX_CN_BASE_URL=' "$HOME/.hermes/.env" | head -1 | cut -d= -f2-)"

export ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-${MINIMAX_CN_API_KEY_VALUE:-}}"
export ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-${MINIMAX_CN_BASE_URL_VALUE:-https://api.minimaxi.com/anthropic}}"
export CLAUDE_MODEL="${CLAUDE_MODEL:-MiniMax-M2.7}"

mkdir -p "$SCRIPT_DIR/data" "$SCRIPT_DIR/logs"

exec "$SCRIPT_DIR/.venv/bin/claude-telegram-bot"
