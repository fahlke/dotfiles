# dotfiles
My dotfiles for MacOS and Ubuntu including zsh configuration.

## Installation

    git clone https://github.com/fahlke/dotfiles.git $HOME/.dotfiles/

    git clone https://github.com/bhilburn/powerlevel9k.git ~/powerlevel9k

    curl -L https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark -o $HOME/.dircolors

    # make a backup of existing files
    mv $HOME/.gitconfig $HOME/.gitconfig.bak
    mv $HOME/.zshrc $HOME/.zshrc.bak
    mv $HOME/.zshenv $HOME/.zshenv.bak
    mv $HOME/.zsh $HOME/.zsh.bak

    # symlink new dotfiles
    ln -sf $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
    ln -sf $HOME/.dotfiles/.zshrc $HOME/.zshrc
    ln -sf $HOME/.dotfiles/.zshenv $HOME/.zshenv
    ln -sf $HOME/.dotfiles/.zsh $HOME/.zsh
    
    # install zsh for Ubuntu
    sudo apt-get install -y zsh
    
    # set default shell for current user to zsh
    sudo chsh -s $(command -v zsh) $(whoami)

    # Patched nerd-fonts must be installed for nerdfont-complete to work properly
    # see: https://github.com/ryanoasis/nerd-fonts/releases/latest

    # for MacOS
    mkdir -p /Users/alex/Library/Fonts/
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip -o /tmp/SourceCodePro.zip
    unzip /tmp/SourceCodePro.zip -d $HOME/Library/Fonts/

    # for Ubuntu
    sudo apt-get install -y unzip fontconfig
    mkdir -p $HOME/.fonts
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip -o /tmp/SourceCodePro.zip
    unzip /tmp/SourceCodePro.zip -d $HOME/.fonts/
    fc-cache -f -v $HOME/.fonts


## iterm Themes

    mkdir -p ~/.iterm-themes
    curl -L https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Afterglow.itermcolors  -o $HOME/.iterm-themes/Afterglow.itermcolors

... or any of https://github.com/mbadolato/iTerm2-Color-Schemes
 

