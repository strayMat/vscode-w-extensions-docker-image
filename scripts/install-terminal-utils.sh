#!/bin/bash

set -e

THEME=default
PLUGINS="git vi-mode"
ZSHRC_APPEND=""
INSTALL_DEPENDENCIES=true

function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

# Install dependencies
apt_install zsh

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 
zshrc_template() {
    _HOME=$1;
    _THEME=$2; shift; shift
    _PLUGINS=$*;

    if [ "$_THEME" = "default" ]; then
        _THEME="powerlevel10k/powerlevel10k"
    fi

    cat <<EOM
export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'
[ -z "$TERM" ] && export TERM=xterm

##### Zsh/Oh-my-Zsh Configuration
export ZSH="$_HOME/.oh-my-zsh"
ZSH_THEME="${_THEME}"
plugins=($_PLUGINS)

EOM
    printf "$ZSHRC_APPEND"
    printf "\nsource \$ZSH/oh-my-zsh.sh\n"
}

# Generate plugin list
plugin_list=""
for plugin in $PLUGINS; do
    if [ "$(echo "$plugin" | grep -E '^http.*')" != "" ]; then
        plugin_name=$(basename "$plugin")
        git clone "$plugin" "$HOME"/.oh-my-zsh/custom/plugins/"$plugin_name"
    else
        plugin_name=$plugin
    fi
    plugin_list="${plugin_list}$plugin_name "
done

# Generate .zshrc
zshrc_template "$HOME" "$THEME" "$plugin_list" > "$HOME"/.zshrc

# Install xan for easy csv manipulation in terminal
curl https://sh.rustup.rs -sSf | sh -s -- -y
export PATH="$HOME/.cargo/bin:$PATH"

cargo install xan