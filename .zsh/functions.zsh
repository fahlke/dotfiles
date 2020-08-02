# compressed file expander (from https://github.com/myfreeweb/zshuery/blob/master/zshuery.sh)
# ----------------------------------------
ex() {
    if [[ -f $1 ]]; then
        case $1 in
            *.tar.bz2) tar xvjf $1;;
            *.tar.gz) tar xvzf $1;;
            *.tar.xz) tar xvJf $1;;
            *.tar.lzma) tar --lzma xvf $1;;
            *.bz2) bunzip $1;;
            *.rar) unrar $1;;
            *.gz) gunzip $1;;
            *.tar) tar xvf $1;;
            *.tbz2) tar xvjf $1;;
            *.tgz) tar xvzf $1;;
            *.zip) unzip $1;;
            *.Z) uncompress $1;;
            *.7z) 7z x $1;;
            *.dmg) hdiutul mount $1;; # mount OS X disk images
            *) echo "'$1' cannot be extracted via >ex<";;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# search for running processes (http://onethingwell.org/post/14669173541/any)
# ----------------------------------------
any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any " >&2 ; return 1
    else
        ps xauwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
    fi
}

# display a neatly formatted path
# ----------------------------------------
path() {
    echo $PATH | tr ":" "\n" | \
        awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
            sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
            sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
            sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
            sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
            print }"
}

# fix for "zsh compinit: insecure directories"
fix-compaudit() {
  compaudit | xargs chmod g-w
  # or: chmod go-w "$(brew --prefix)/share"
}

# Mac specific functions
# ----------------------------------------
if [[ $IS_MAC -eq 1 ]]; then
    # view man pages in Preview
    pman() {
        ps=$(mktemp -t manpageXXXX).ps ; man -t $@ > "$ps" ; open "$ps" ;
    }

    # upgrade homebrew installed programs
    brew-latest() {
        if [[ -z "$1" ]] ; then
            echo "brew-latest - upgrade all brew installed programs" >&2
            echo "Usage: brew-latest all" >&2
            return 1
        elif [[ "$1" == "all" ]] ; then
            brew update
            brew upgrade;
            brew cask upgrade;
            return 0;
        fi
    }
fi

# Initialize a new Ginkgo project
ginkgo-init() {
  ginkgo bootstrap # set up a new ginkgo suite
  ginkgo generate  # will create a sample test file.  edit this file and add your tests then...
}

if [[ $DOTFILES_DEBUG -eq 1 ]]; then
    echo "DEBUG: sourced functions.zsh"
fi
