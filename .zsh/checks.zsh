# checks for package managers
if [[ $(uname) = 'Linux' ]]; then
    export IS_LINUX=1
fi

if [[ $(uname) = 'Darwin' ]]; then
    export IS_MAC=1
fi

if [[ -x $(command -v brew) ]]; then
    export HAS_BREW=1
fi

if [[ -x $(command -v apt-get) ]]; then
    export HAS_APT=1
fi

if [[ -x $(command -v yum) ]]; then
    export HAS_YUM=1
fi

if [[ $DOTFILES_DEBUG -eq 1 ]]; then
    echo "DEBUG: sourced checks.zsh"
fi
