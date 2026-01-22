# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# ALIASES
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias resource='source ~/.bashrc'
alias fkill="ps -ax | fzf | awk '{print $1}' | xargs kill"
alias imgcat="wezterm imgcat"

# Stonks
alias stonks='curl terminal-stocks.dev/ARM,AMD'
stock() {
    if [ -z "$1" ]; then
        echo "Usage: stock SYMBOL"
        return 1
    fi
    curl -s "terminal-stocks.dev/$1"
}


# PROMPT
host_name() {
    # check for $DOTFILE_HOSTNAME, use that if present
    # (allows checking hostname logic to be done in work bashrc)
    if [ -n "$DOTFILE_HOSTNAME" ]; then
        echo -e "$DOTFILE_HOSTNAME"
        return
    fi
    raw=$(hostname)
    echo -e "$raw"
}

git_branch() {
    raw=$(git branch --show-current 2>/dev/null)
    if [ -n "$raw" ]; then
        echo -e " ($raw)"
    else
        echo -e ""
    fi
}
COLOUR_RESET='\[\e[0m\]'
COLOUR_RED='\[\e[38;5;196m\]'
COLOUR_YELLOW='\[\e[38;5;228m\]'
COLOUR_BLUE='\[\e[38;5;32m\]'
COLOUR_GREEN='\[\e[38;5;40m\]'
COLOUR_GREEN='\[\e[92;1m\]'

export PS1="\n[ ${COLOUR_YELLOW}\u${COLOUR_RED}@${COLOUR_GREEN}\$(host_name)${COLOUR_RESET} \w${COLOUR_BLUE}\$(git_branch)${COLOUR_RESET} ]\n${COLOUR_GREEN}\$${COLOUR_RESET} "

export PATH=$(realpath ~/bin/):$PATH
export PATH=$(realpath ~/scripts):$PATH
export PATH=$(realpath ~/.fzf/bin):$PATH

# use fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
