# dotfiles
My dotfiles for MacOS and Ubuntu including zsh configuration.

## Installation

### Prepare environment (MacOS only)

Install Homebrew and Ansible, as well as my default set of tools and applications.

    bash <(curl -fsSL http://sre.fahlke.io/homebrew/installation)
    bash <(curl -fsSL http://sre.fahlke.io/ansible/installation)
    ansible-playbook <(curl -fsSL http://sre.fahlke.io/ansible/apps)
    ansible-playbook <(curl -fsSL http://sre.fahlke.io/ansible/zsh)

### Setup dotfiles and configure ZSH

    git clone -b master https://github.com/fahlke/dotfiles.git $HOME/.dotfiles/

    git clone https://github.com/bhilburn/powerlevel9k.git ~/powerlevel9k

    curl -L https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark -o $HOME/.dircolors

    # symlink new dotfiles (will overwrite any existing file)
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
 

