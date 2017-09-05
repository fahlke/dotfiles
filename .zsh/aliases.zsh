# prevent autocorrect from "fixing" the following aliases
# ----------------------------------------
alias g8='nocorrect g8'

# colorize grep in green
alias grep='grep --color=auto'
export GREP_COLOR='1;32'

# directory helper
# ----------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias l='ls -al'
alias ls='ls -GFh' # Colorize output, add file type indicator, and put sizes in human readable format
alias ll='ls -GFhl' # Same as above, but in long listing format
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias dus="du -sckx * | sort -nr" # directories sorted by size

# Mac only
# ----------------------------------------
if [[ $IS_MAC -eq 1 ]]; then
	# alias to open a file with MacOS Quick Look
    alias ql='qlmanage -p 2>/dev/null'
    # alias to show all Mac App store apps
    alias apps='mdfind "kMDItemAppStoreHasReceipt=1"'
    # refresh brew by upgrading all outdated casks
    alias refreshbrew='brew outdated | while read cask; do brew upgrade $cask; done'
fi

# Git
# ----------------------------------------
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gpl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'
alias gta='git tag -a -m'
alias gf='git reflog'
alias gv='git log --pretty=format:'%s' | cut -d " " -f 1 | sort | uniq -c | sort -nr'

# leverage aliases from ~/.gitconfig
alias gh='git hist'
alias gt='git today'

# curiosities
# gsh shows the number of commits for the current repos for all developers
alias gsh="git shortlog | grep -E '^[ ]+\w+' | wc -l"

# gu shows a list of all developers and the number of commits they've made
alias gu="git shortlog | grep -E '^[^ ]'"

# Python virtualenv
# ----------------------------------------
alias mkenv='mkvirtualenv'
alias on="workon"
alias off="deactivate"

# Various stuff
# ----------------------------------------
alias 'rm=rm -i' # make rm command (potentially) less destructive
alias  cls='clear' # clear the screen

if [[ $DOTFILES_DEBUG -eq 1 ]]; then
    echo "DEBUG: sourced aliases.zsh"
fi