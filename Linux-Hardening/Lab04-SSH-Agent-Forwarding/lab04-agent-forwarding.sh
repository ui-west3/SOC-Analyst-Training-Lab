#!/bin/bash

# Lab 04: SSH Agent Forwarding Demo
# This script prepares your local environment and opens an SSH session
# to the jump host with agent forwarding enabled.

set -euo pipefail

# --- CONFIGURATION (edit for your lab setup) ---
SSH_KEY_PATH="${SSH_KEY_PATH:-$HOME/.ssh/id_ed25519}"
SSH_USER="${SSH_USER:-ubuntu}"
JUMP_HOST="${JUMP_HOST:-jump-host}"

echo "🔑 Starting Lab04: SSH Agent Forwarding"
echo "Using key: $SSH_KEY_PATH"
echo "User:      $SSH_USER"
echo "Jump host: $JUMP_HOST"
echo

if [[ ! -f "$SSH_KEY_PATH" ]]; then
  echo "❌ SSH key not found at: $SSH_KEY_PATH"
  echo "Create a key first, for example:"
  echo "  ssh-keygen -t ed25519 -f \"$HOME/.ssh/id_ed25519\" -C \"lab04\""
  exit 1
fi

echo "1) Starting ssh-agent (if not already running)..."
eval "$(ssh-agent -s)" >/dev/null

echo "2) Adding your key to the agent..."
ssh-add "$SSH_KEY_PATH"
echo "✅ Key added to ssh-agent."
echo

echo "3) Connecting to the jump host with agent forwarding:"
echo "   ssh -A ${SSH_USER}@${JUMP_HOST}"
echo
echo "After you log in to the jump host, you can SSH further inside your lab, for example:"
echo "   ssh internal-user@internal-host"
echo
echo "💡 Your private key never leaves your local machine – only the agent is forwarded."
echo

ssh -A "${SSH_USER}@${JUMP_HOST}"

