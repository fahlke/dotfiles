# https://github.com/pyenv/pyenv#basic-github-checkout
if [[ ! -f "$HOME/.pyenv/libexec/pyenv" ]]; then
    git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
fi

# https://github.com/pyenv/pyenv-virtualenv#installation
if [[ ! -f "$HOME/.pyenv/plugins/pyenv-virtualenv/bin/pyenv-virtualenv" ]]; then
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$HOME/.pyenv/plugins/pyenv-virtualenv"
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
