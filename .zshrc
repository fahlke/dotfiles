# enable debug mode for dotfiles
DOTFILES_DEBUG=0

[[ ! -f $HOME/.zsh/p10k.zsh ]] || source $HOME/.zsh/p10k.zsh
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# suppress "Last login" message in MacOS
[[ -f "$HOME/.hushlogin" ]] || touch "$HOME/.hushlogin"

# checks.zsh and colors.zsh must be sourced first
source "$HOME/.zsh/checks.zsh"
source "$HOME/.zsh/colors.zsh"

for file in $(find "$HOME/.zsh" -follow -type f -name "*.zsh"); do
  source "${file}"
done

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
