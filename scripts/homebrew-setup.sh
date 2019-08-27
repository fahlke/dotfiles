#!/bin/bash

# usage: /bin/bash <(curl -fsSL http://sre.fahlke.io/homebrew/installation)

# define output colors
readonly COLOR_RED='\033[0;31m'
readonly COLOR_ORANGE='\033[0;33m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_RESET='\033[0m'

# temporary setup path for Homebrew
export PATH="/usr/local/bin:$PATH"

# install Homebrew
if [[ $(command -v brew >/dev/null; echo $?) -ne 0 ]]; then
  echo -e "${COLOR_GREEN}Installing Homebrew (might need sudo)...${COLOR_RESET}"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo -e "${COLOR_ORANGE}Warning:${COLOR_RESET} Homebrew already installed, skipping installation..."
fi

# disable Homebrew analytics
echo -e "${COLOR_GREEN}Disabling Homebrew analytics...${COLOR_RESET}"
brew analytics off

# verify Homebrew installation
echo -e "${COLOR_GREEN}Verifying Homebrew installation...${COLOR_RESET}"
brew doctor
if [[ "$?" -ne 0 ]]; then
  echo -e "${COLOR_RED}Error:${COLOR_RESET} Homebrew setup incomplete!"
  exit 1
fi

echo -e "${COLOR_GREEN}Ready to use Homebrew!${COLOR_RESET}"
