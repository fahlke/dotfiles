#!/bin/bash

# usage: /bin/bash <(curl -fsSL http://sre.fahlke.io/ansible/installation)

# define output colors
readonly COLOR_RED='\033[0;31m'
readonly COLOR_ORANGE='\033[0;33m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_RESET='\033[0m'

# temporary setup path for homebrew
export PATH="/usr/local/bin:$PATH"

if [[ $(command -v brew >/dev/null; echo $?) -ne 0 ]]; then
  echo -e "${COLOR_RED}Error:${COLOR_RESET} brew command not found. Install Homebrew first (https://brew.sh/)."
  exit 1
fi

# install Ansible
echo -e "${COLOR_GREEN}Installing ansible...${COLOR_RESET}"
brew install ansible
if [[ $? -ne 0 ]]; then
  exit 1
fi

echo -e "${COLOR_GREEN}Ready to use Ansible!${COLOR_RESET}"
