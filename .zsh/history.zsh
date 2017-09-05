# all zsh history related settings can be found in setopt.zsh in section "History"
HISTSIZE=10000
SAVEHIST=9000
HISTFILE=$HOME/.zsh_history

if [[ $DOTFILES_DEBUG -eq 1 ]]; then
    echo "DEBUG: sourced history.zsh"
fi
