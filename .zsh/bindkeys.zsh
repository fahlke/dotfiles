# To see the key combo you want to use just do:
# cat > /dev/null
# And press it

#bindkey "[B"      history-search-forward               # down arrow
#bindkey "[A"      history-search-backward              # up arrow

if [[ $DOTFILES_DEBUG -eq 1 ]]; then
    echo "DEBUG: sourced bindkeys.zsh"
fi
