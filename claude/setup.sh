#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="${HOME}/.claude"

# Ensure ~/.claude directory exists
mkdir -p "${CLAUDE_DIR}"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"

    if [ -e "${target}" ] || [ -L "${target}" ]; then
        if [ -L "${target}" ]; then
            # Already a symlink, remove it
            rm "${target}"
        else
            # Regular file/directory, backup it
            echo "  Backing up existing ${target} to ${target}.backup"
            mv "${target}" "${target}.backup"
        fi
    fi

    ln -sf "${source}" "${target}"
    echo "  Created symlink: ${target} -> ${source}"
}

echo "Setting up Claude Code configuration..."

# Symlink configuration files
echo "Symlinking configuration files..."
create_symlink "${DOTFILES_DIR}/claude/CLAUDE.md" "${CLAUDE_DIR}/CLAUDE.md"
create_symlink "${DOTFILES_DIR}/claude/AGENTS.md" "${CLAUDE_DIR}/AGENTS.md"
create_symlink "${DOTFILES_DIR}/claude/settings.json" "${CLAUDE_DIR}/settings.json"

# Symlink feature directories
echo "Symlinking feature directories..."
create_symlink "${DOTFILES_DIR}/claude/hooks" "${CLAUDE_DIR}/hooks"
create_symlink "${DOTFILES_DIR}/claude/scripts" "${CLAUDE_DIR}/scripts"
create_symlink "${DOTFILES_DIR}/claude/commands" "${CLAUDE_DIR}/commands"
create_symlink "${DOTFILES_DIR}/claude/agents" "${CLAUDE_DIR}/agents"
create_symlink "${DOTFILES_DIR}/claude/skills" "${CLAUDE_DIR}/skills"

# Set executable permissions
echo "Setting executable permissions..."
chmod +x "${DOTFILES_DIR}/claude/hooks/"*.py 2>/dev/null || true
chmod +x "${DOTFILES_DIR}/claude/scripts/"*.sh 2>/dev/null || true

echo "Claude Code setup complete!"
