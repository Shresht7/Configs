# Add opencode cli to the PATH
if [ -d "$HOME/.opencode/bin" ]; then
    PATH="$PATH:$HOME/.opencode/bin"
fi

# opencode cli completions
if command -v opencode &> /dev/null; then
    eval "$(opencode --completions bash)"
fi
