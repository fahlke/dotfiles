#!/bin/bash

# usage: bash <(curl -fsSL http://sre.fahlke.io/homebrew/installation)

# define output colors
readonly COLOR_RED='\033[0;31m'
readonly COLOR_ORANGE='\033[0;33m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_RESET='\033[0m'

# temporary setup path for Homebrew
export PATH="/usr/local/bin:$PATH"

# install Homebrew
if [[ ! -f "/usr/local/bin/brew" ]]; then
  echo -e "${COLOR_GREEN}Installing Homebrew (might need sudo)...${COLOR_RESET}"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo -e "${COLOR_ORANGE}Homebrew already installed, skipping installation...${COLOR_RESET}"
fi

# disable Homebrew analytics
echo -e "\n${COLOR_GREEN}Disabling Homebrew analytics...${COLOR_RESET}"
brew analytics off

# verify Homebrew installation
echo -e "\n${COLOR_GREEN}Verifying Homebrew installation...${COLOR_RESET}"
brew doctor
if [[ "$?" -ne 0 ]]; then
  echo -e "\n${COLOR_RED}Homebrew setup incomplete!${COLOR_RESET}"
  exit 1
fi

echo -e "\n${COLOR_GREEN}Ready to use Homebrew!${COLOR_RESET}"

echo -e "${COLOR_GREEN}Don't forget to add /usr/local/bin to your PATH.${COLOR_RESET}"
echo -e "    export PATH="/usr/local/bin:$PATH""

exit 0
