# dotfiles
My dotfiles for macOS including zsh configuration.

## Installation

### Setup dotfiles and configure ZSH

    git clone -b master https://github.com/fahlke/dotfiles.git $HOME/.dotfiles/

    # symlink new dotfiles (will overwrite any existing file)
    ln -sfn $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
    ln -sfn $HOME/.dotfiles/.gitignore $HOME/.gitignore
    ln -sfn $HOME/.dotfiles/.zshrc     $HOME/.zshrc
    ln -sfn $HOME/.dotfiles/.zshenv    $HOME/.zshenv
    ln -sfn $HOME/.dotfiles/.zsh       $HOME/.zsh

    $HOME/.dotfiles/scripts/apps

    curl -L https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark -o $HOME/.dircolors

## iTerm themes

    mkdir -p ~/.iterm-themes
    curl -L https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Afterglow.itermcolors  -o $HOME/.iterm-themes/Afterglow.itermcolors

... or any of https://github.com/mbadolato/iTerm2-Color-Schemes
 