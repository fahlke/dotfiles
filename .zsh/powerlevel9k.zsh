POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(host user dir_writable dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv command_execution_time time battery)

POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
POWERLEVEL9K_TIME_BACKGROUND='237'
POWERLEVEL9K_TIME_FOREGROUND='242'

POWERLEVEL9K_USER_DEFAULT_BACKGROUND='237'
POWERLEVEL9K_USER_DEFAULT_FOREGROUND='242'

POWERLEVEL9K_USER_ROOT_BACKGROUND='237'
POWERLEVEL9K_USER_ROOT_FOREGROUND='red'
POWERLEVEL9K_ROOT_ICON=""

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
POWERLEVEL9K_DIR_SHOW_WRITABLE=false
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND='237'
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND='red'

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='245'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='237'

POWERLEVEL9K_HOST_TEMPLATE='%M' # fqdn of the host
POWERLEVEL9K_HOST_ICON="\uF109" # 
POWERLEVEL9K_SSH_ICON="\uF489"  # 
POWERLEVEL9K_HOST_LOCAL_BACKGROUND='237'
POWERLEVEL9K_HOST_LOCAL_FOREGROUND='242'
POWERLEVEL9K_HOST_REMOTE_BACKGROUND='237'
POWERLEVEL9K_HOST_REMOTE_FOREGROUND='red'

source "$HOME/powerlevel9k/powerlevel9k.zsh-theme"
