# enable debug mode for dotfiles
DOTFILES_DEBUG=0

# checks.zsh and colors.zsh must be sourced first
source "${HOME}/.zsh/checks.zsh"
source "${HOME}/.zsh/colors.zsh"

# source all other .zsh-files
for file in $HOME/.zsh/* ; do
    if [ -f "${file}" ] ; then
        source "${file}"
    fi
done
