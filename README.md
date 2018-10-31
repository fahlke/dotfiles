# dotfiles
My dotfiles for MacOS and Ubuntu including zsh configuration.

## Installation

    git clone https://github.com/fahlke/dotfiles.git $HOME/.dotfiles/

    git clone https://github.com/bhilburn/powerlevel9k.git ~/powerlevel9k

    curl -L https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark -o $HOME/.dircolors

    # make a backup of existing files
    mv $HOME/.zshrc $HOME/.zshrc.bak
    mv $HOME/.zshenv $HOME/.zshenv.bak
    mv $HOME/.zsh $HOME/.zsh.bak
    mv $HOME/.gitconfig $HOME/.gitconfig.bak

    # install new dotfiles
    ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
    ln -s $HOME/.dotfiles/.zshenv $HOME/.zshenv
    ln -s $HOME/.dotfiles/.zsh $HOME/.zsh
    ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig

    # Patched nerd-fonts must be installed for nerdfont-complete to work properly
    # see: https://github.com/ryanoasis/nerd-fonts/releases/latest

    # for MacOS
    mkdir -p /Users/alex/Library/Fonts/
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v1.1.0/SourceCodePro.zip -o /tmp/SourceCodePro.zip
    unzip /tmp/SourceCodePro.zip -d $HOME/Library/Fonts/

    # for Ubuntu
    mkdir -p $HOME/.fonts
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v1.1.0/SourceCodePro.zip -o /tmp/SourceCodePro.zip
    unzip /tmp/SourceCodePro.zip -d $HOME/.fonts/
    fc-cache -f -v $HOME/.fonts


## iterm Themes

 - https://github.com/MartinSeeler/iterm2-material-design

    curl -L https://raw.githubusercontent.com/MartinSeeler/iterm2-material-design/master/material-design-colors.itermcolors -o $HOME/.iterm-material-theme

 - or any of https://github.com/mbadolato/iTerm2-Color-Schemes

