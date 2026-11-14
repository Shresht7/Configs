# ---
# FZF
# ---

# Skip if fzf not installed
command -v fzf >/dev/null 2>&1 || return

# Use fd for fzf default command if available
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type file'
else
    # fallback to find if fd not available
    export FZF_DEFAULT_COMMAND='find . -type f'
fi

# Fuzzy finder with bat preview
if command -v bat &> /dev/null; then
    alias preview="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --reverse"
fi
