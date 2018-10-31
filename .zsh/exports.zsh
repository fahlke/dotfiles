# Currently this path is appended to dynamically when picking a ruby version
# zshenv has already started PATH with rbenv so append only here
export PATH=$PATH:~/bin
export PATH=$PATH:/usr/local/go/bin

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS='-arch x86_64'

export LESS='--ignore-case --raw-control-chars'
export PAGER='less'
export EDITOR='subl -w'

# CTAGS Sorting in VIM/Emacs is better behaved with this in place
export LC_COLLATE=C

# GOPATH export for sublime
export GOPATH=$(go env GOPATH)

export PATH="/usr/local/sbin:$PATH"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
export GOROOT="/usr/local/opt/go/libexec"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

export HOMEBREW_NO_ANALYTICS=1

if [[ $DOTFILES_DEBUG -eq 1 ]]; then
    echo "DEBUG: sourced exports.zsh"
fi
