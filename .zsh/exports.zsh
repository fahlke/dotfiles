# Currently this path is appended to dynamically when picking a ruby version
# zshenv has already started PATH with rbenv so append only here
export PATH=$PATH:$HOME/bin
export PATH=$PATH:/opt/homebrew/bin

# this might be needed for Rancher Desktop
#export PATH=$PATH:$HOME/.rd/bin

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS='-arch x86_64'

export LESS='--ignore-case --raw-control-chars'
export PAGER='less'
export EDITOR='code --wait'

# CTAGS Sorting in VIM/Emacs is better behaved with this in place
export LC_COLLATE=C

# enforce english
export LANG=en_US.UTF-8

# GOPATH export for sublime
#export GOPATH=$(go env GOPATH)
export GOPATH="$HOME/go"
export GOROOT="/opt/homebrew/opt/go/libexec/"
export PATH="$PATH:$GOPATH/bin"

# gcloud
#source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
#source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

# add Visual Studio Code to PATH
if [[ $IS_MAC -eq 1 ]]; then
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
fi

# disable Homebrew analytics
if [[ $IS_MAC -eq 1 ]]; then
  export HOMEBREW_NO_ANALYTICS=1
fi

if [[ $DOTFILES_DEBUG -eq 1 ]]; then
    echo "DEBUG: sourced exports.zsh"
fi
