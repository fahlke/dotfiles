#!/bin/bash

# usage: bash <(curl -fsSL http://sre.fahlke.io/ansible/installation)

# define output colors
readonly COLOR_RED='\033[0;31m'
readonly COLOR_ORANGE='\033[0;33m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_RESET='\033[0m'

# temporary setup path for homebrew
export PATH="/usr/local/bin:$PATH"

# install Ansible
if [[ ! -f "/usr/local/bin/brew" ]]; then
  echo -e "${COLOR_RED}Homebrew not found. Consider running the following command first:${COLOR_RESET}"
  echo -e ""
  echo -e "    bash <(curl -fsSL https://sre.fahlke.io/homebrew/installation/)"
  exit 1
else
  # install ansible
  echo -e "${COLOR_GREEN}Installing ansible...${COLOR_RESET}"
  brew install ansible
fi

echo -e "\n${COLOR_GREEN}Ready to use Ansible!${COLOR_RESET}"

exit 0
