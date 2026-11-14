# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples

# INTERACTIVE SHELL GUARD
# -----------------------

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# BASE
# ----

# Source global definitions (Crucial for Fedora)
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# HISTORY CONFIGURATION
# ---------------------

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# SHELL OPTIONS
# -------------

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# COLORS
# ------

# Enable color support for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Colored GCC warnings and errors (useful for C/C++ compilation)
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# PATH
# ----

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Golang
if [ -d "$HOME/go/bin" ]; then
    PATH="$PATH:$HOME/go/bin"
fi

# Rust (Cargo)
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# OpenCode CLI
if [ -d "$HOME/.opencode/bin" ]; then
    PATH="$PATH:$HOME/.opencode/bin"
fi

# Export PATH variable
export PATH

# EDITOR
# ------

# If micro is installed, use it as default editor
if command -v micro >/dev/null 2>&1; then
    export EDITOR=micro
# Otherwise, fallback to nano
elif command -v nano >/dev/null 2>&1; then
    export EDITOR=nano
else
    export EDITOR=vi
fi

# MISCELLANEOUS
# -------------

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Identify Debian/Ubuntu (WSL) chroot. Used in prompt. Safely ignored on Fedora etc.
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# ENVIRONMENT-SPECIFIC
# --------------------

OS_ENV="unknown"

# Fedora
if [ -f /etc/fedora-release ] || grep -q 'ID=fedora' /etc/os-release 2>/dev/null; then
    OS_ENV="fedora"

# WSL (Ubuntu)
elif grep -qi microsoft /proc/version 2>/dev/null; then
    OS_ENV="wsl"
    # Set Docker host for WSL
    export DOCKER_HOST=unix:///var/run/docker.sock

# Git Bash on Windows
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    OS_ENV="windows"

# Else, just linux
else
    OS_ENV="linux"
fi

# Load platform-specific overrides (e.g., ~/.bashrc.wsl, ~/.bashrc.fedora)
if [ -f ~/.bashrc."$OS_ENV" ]; then
    . ~/.bashrc."$OS_ENV"
fi

# TAB COMPLETION
# --------------

# Enable programmable tab completion (for WSL and Fedora)
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# OpenCode CLI completions
if command -v opencode &> /dev/null; then
    eval "$(opencode --completions bash)"
fi

# ALIASES
# -------

# Load alias definitions from a dedicated file
# See /usr/share/doc/bash-doc/examples in the bash-doc package
if [ -f ~/.bash_aliases ]; then
    . ~/Configs/bash/.bash_aliases
fi

# LOCAL
# -----

# Load local, private or machine-specific bash configuration
if [ -f ~/.bash_local ]; then
    . ~/Configs/bash/.bash_local
fi

# PROMPT
# ------

# Starship
# eval "$(starship init bash)"

# Oh-My-Posh
eval "$(oh-my-posh init bash --config ~/Configs/Oh-My-Posh/Themes/s7.omp.yaml)"

# FZF
# ---

if command -v fzf >/dev/null 2>&1; then
    if command -v fd >/dev/null 2>&1; then
        # Use fd for fzf default command if available
        export FZF_DEFAULT_COMMAND='fd --type file'
    else
        # fallback to find if fd not available
        export FZF_DEFAULT_COMMAND='find . -type f'
    fi
fi
