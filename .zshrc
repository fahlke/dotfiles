# enable debug mode for dotfiles
DOTFILES_DEBUG=0

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# suppress "Last login" message in MacOS
[[ -f "$HOME/.hushlogin" ]] || touch "$HOME/.hushlogin"

# checks.zsh and colors.zsh must be sourced first
source "${HOME}/.zsh/checks.zsh"
source "${HOME}/.zsh/colors.zsh"

# source all other .zsh-files
for file in $HOME/.zsh/* ; do
    if [ -f "${file}" ] ; then
        source "${file}"
    fi
done

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/kustomize kustomize
