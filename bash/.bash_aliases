# ------------
# BASH ALIASES
# ------------

# Desktop notification for long-running commands (e.g., sleep 10; alert)
# Safely checks if notify-send exists before creating the alias
if command -v notify-send &> /dev/null; then
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Fuzzy finder with bat preview
if command -v fzf &> /dev/null && command -v bat &> /dev/null; then
    alias preview="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --reverse"
fi
