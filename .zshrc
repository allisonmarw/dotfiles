#!/usr/bin/env zsh
# === Shell ===
export CLICOLOR=1
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export MYPROMPT="${MYPROMPT:-spaceship-async}"

# === Profiling ===
if [[ ${+PROFILING} -eq 1 ]]; then
    zmodload zsh/zprof 
    PS4=$'%D{%M%S%.} %N:%i> '
    zprof
fi


# === zprofile if not autoloaded ===
[[ ${+ZPROFILE_LOADED} -eq 1 ]] \
    || source "${HOME}/.zprofile"

[[ ${+ZSH_ALIASES_LOADED} -eq 1 ]] \
    || source "${HOME}/.zsh_aliases"

# === PATHS and EVNS 
# Location of my dotfiles
DOTFILES=$HOME/.dotfiles
DOTFILESDEPS=${DOTFILES:-$HOME}/deps

# Standard path includes
path=(
    /usr/local/{bin,sbin,opt}
    $path
)
if command -v brew &>/dev/null; then
    # Add to start of path
    path=(
        $(brew --prefix coreutils)/libexec/gnubin
        $(brew --prefix python)/libexec/bin
        $(brew --prefix)/bin/
        $path
    )
elif [[ "${DISTRO:="darwin"}" == "darwin" ]]; then
    # Auto install brew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Add dotfiles to end of path
path=(
    $path
    ${DOTFILES}/scripts
    ${HOME}/bin
)

typeset -U path

COMPLETION_WAITING_DOTS="true"

# change the size of history files
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;

# Homebrew
# This is one of examples why I want to keep my dotfiles private
#export HOMEBREW_GITHUB_API_TOKEN=MY_GITHUB_TOKEN
#export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Autoenv https://github.com/Tarrasch/zsh-autoenv
# Great plugin to automatically modify path when it sees .env file
# I use it for example to automatically setup docker/rbenv/pyenv environments
#AUTOENV_FILE_ENTER=.env
#AUTOENV_HANDLE_LEAVE=1 # Turn on/off handling leaving an env
#AUTOENV_FILE_LEAVE=.envl

# tmux plugin settings
# this always starts tmux
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOSTART_ONCE=true
ZSH_TMUX_FIXTERM=true
ZSH_TMUX_AUTOQUIT=false

# Powerlevel9k is the best theme for prompt, I like to keep it in dark gray colors
export DEFAULT_USER=awampler

# dumb terminal can be a vim dump terminal in that case don't try to load plugins
if [ ! $TERM = dumb ]; then
    ZGEN_AUTOLOAD_COMPINIT=true

    # If user is root it can have some issues with access to competition files
    if [[ "${USER}" == "root" ]]; then
        ZGEN_AUTOLOAD_COMPINIT=false
    fi

    # load zgen
    source $DOTFILESDEPS/zgen/zgen.zsh
    if [[ ${ZGENRESET:-N} =~ ^[Yy]$ ]]; then
        zgen reset
    fi

    # configure zgen
    if ! zgen saved; then

        # zgen will load oh-my-zsh and download it if required
        zgen oh-my-zsh

        # list of plugins from zsh I use
        # see https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
        # zgen oh-my-zsh plugins/bower
        # zgen oh-my-zsh plugins/brew
        zgen oh-my-zsh plugins/git
        zgen oh-my-zsh plugins/kubectl
        zgen oh-my-zsh plugins/git-extras
        zgen oh-my-zsh plugins/gitignore
        zgen oh-my-zsh plugins/git-completion
        zgen oh-my-zsh plugins/osx
        zgen oh-my-zsh plugins/pip
        zgen oh-my-zsh plugins/python
        zgen oh-my-zsh plugins/sudo
        zgen oh-my-zsh plugins/tmuxinator
        zgen oh-my-zsh plugins/terraform
        zgen oh-my-zsh plugins/urltools
        zgen oh-my-zsh plugins/vault
        zgen oh-my-zsh plugins/web-search
        zgen oh-my-zsh plugins/fzf
        zgen oh-my-zsh plugins/kubectl
        zgen oh-my-zsh plugins/openssl

        zgen load zsh-users/zsh-syntax-highlighting
        # https://github.com/Tarrasch/zsh-autoenv
        #zgen load Tarrasch/zsh-autoenv
        # https://github.com/zsh-users/zsh-completions
        zgen load joel-porquet/zsh-dircolors-solarized
        zgen load zsh-users/zsh-completions src

        # my own plugins each of these folders use init.zsh entry point
        # zgen load $DOTFILES/plugins/fbtools

        zgen load romkatv/powerlevel10k powerlevel10k
        zgen load $DOTFILES/themes/p10k

        zgen oh-my-zsh plugins/vi-mode
        # async update vim mode
        # zgen load dritter/powerlevel9k powerlevel9k.zsh-theme async_all_the_segments

        zgen save
    fi

fi

[[ -f ~/.zprofile ]] && source ~/.zprofile
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Standard path includes
path=(
    /usr/local/{bin,sbin,opt}
    $path
)
# Brew for OSX
if command -v brew &>/dev/null; then
    # Add to start of path
    path=(
        $(brew --prefix coreutils)/libexec/gnubin
        $(brew --prefix python)/libexec/bin
        $(brew --prefix)/bin/
        $path
    )
elif [[ "${DISTRO:="darwin"}" == "darwin" ]]; then
    echo "Install Homebrew" >&2
    # add to end of path
fi

if [[ -n "${DOTFILES}" ]]; then 
    path=(
        $path
        ${DOTFILES}/scripts
        ${HOME}/bin
    )
	typeset -U path
fi

COMPLETION_WAITING_DOTS="true"

# change the size of history files
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;

# === Fzf ===
# End of lines configured by zsh-newuser-install
# export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# === Completion ===
# Bindkey ... autosuggest-*
#   autosuggest-accept: Accepts the current suggestion.
#   autosuggest-execute: Accepts and executes the current suggestion.
#   autosuggest-clear: Clears the current suggestion.
#   autosuggest-fetch: Fetches a suggestion (works even when suggestions are disabled).
#   autosuggest-disable: Disables suggestions.
#   autosuggest-enable: Re-enables suggestions.
#   autosuggest-toggle: Toggles between enabled/disabled suggestions.

# Auto complete from anywhere in word
setopt COMPLETE_IN_WORD BRACE_CCL AUTO_PARAM_SLASH
# automatically decide when to page a list of completions
# LISTMAX=0

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=64
#export ZSH_AUTOSUGGEST_STRATEGY=("match_prev_cmd" "completion")
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1,underline" # Red
export ZSH_AUTOSUGGEST_USE_ASYNC="y"
[[ ${+ZSH_HIGHLIGHT_STYLES} == 1 ]] && \
export ZSH_HIGHLIGHT_STYLES[comment]='fg=yellow'

# === Customization ===
setopt extendedglob nomatch

# keep background processes at full speed
# setopt NOBGNICE
# setopt HUP

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# Vim mode
bindkey -v
