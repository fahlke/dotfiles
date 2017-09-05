# enable debug mode for dotfiles
DOTFILES_DEBUG=0

# checks must be done first
source "${HOME}/.zsh/checks.zsh"

for file in $HOME/.zsh/* ; do
    if [ -f "${file}" ] ; then
        source "${file}"
    fi
done

source "${HOME}/.dotfiles/z/z.sh"

# install instructions: https://github.com/bhilburn/powerlevel9k
POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='215'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='215'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(battery context dir_writable dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv command_execution_time time)

POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_DIR_SHOW_WRITABLE=true

POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
POWERLEVEL9K_TIME_BACKGROUND='237'
POWERLEVEL9K_TIME_FOREGROUND='242'

POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='237'
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='245'

POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_STATUS_OK_BACKGROUND='237'
POWERLEVEL9K_STATUS_OK_FOREGROUND='green'
POWERLEVEL9K_STATUS_ERROR_BACKGROUND='237'
POWERLEVEL9K_STATUS_ERROR_FOREGROUND='red'

POWERLEVEL9K_BATTERY_VERBOSE=false
POWERLEVEL9K_BATTERY_CHARGING='215'
POWERLEVEL9K_BATTERY_CHARGED='green'
POWERLEVEL9K_BATTERY_DISCONNECTED='$DEFAULT_COLOR'
POWERLEVEL9K_BATTERY_LOW_THRESHOLD='10'
POWERLEVEL9K_BATTERY_LOW_COLOR='red'
POWERLEVEL9K_BATTERY_STAGES=($'\uF244' $'\uF243' $'\uF242' $'\uF241' $'\uF240' )
POWERLEVEL9K_BATTERY_LOW_BACKGROUND='237'
POWERLEVEL9K_BATTERY_LOW_FOREGROUND='242'
POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND='237'
POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND='242'
POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND='237'
POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND='242'
POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND='237'
POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND='242'
POWERLEVEL9K_BATTERY_LOW_VISUAL_IDENTIFIER_COLOR='red'
POWERLEVEL9K_BATTERY_CHARGING_VISUAL_IDENTIFIER_COLOR='215'
POWERLEVEL9K_BATTERY_CHARGED_VISUAL_IDENTIFIER_COLOR='green'
POWERLEVEL9K_BATTERY_DISCONNECTED_VISUAL_IDENTIFIER_COLOR='242'

POWERLEVEL9K_DIR_HOME_BACKGROUND='237'
POWERLEVEL9K_DIR_HOME_FOREGROUND='249'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='237'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='249'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='237'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='249'

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='245'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='237'

#git clone https://github.com/bhilburn/powerlevel9k.git ~/powerlevel9k
source "$HOME/powerlevel9k/powerlevel9k.zsh-theme"

# patched nerd-fonts must be installed for awesome-fontconfig to work properly
# see: https://github.com/ryanoasis/nerd-fonts/releases/latest
#mkdir -p /Users/alex/Library/Fonts/
#curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v1.1.0/SourceCodePro.zip -o /tmp/SourceCodePro.zip
#unzip /tmp/SourceCodePro.zip -d /Users/alex/Library/Fonts/

# iterm2 themes:
#https://github.com/MartinSeeler/iterm2-material-design
#or any of https://github.com/mbadolato/iTerm2-Color-Schemes

