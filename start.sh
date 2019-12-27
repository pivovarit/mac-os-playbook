#!/bin/bash

set -e

readonly REPOSITORY="https://github.com/pivovarit/mac-os-playbook"
TARGET="$(pwd)"

RED=""
GREEN=""
BLUE=""
RESET=""

error() {
    echo "${RED}""Error: $@""${RESET}" >&2
    exit 1
}

ok() {
    echo "${GREEN}""Info   | OK        | $@""${RESET}"
}

installing() {
    echo "${BLUE}""Info   | Install   | $@""${RESET}"
}

generate_temp_dir() {
    PLAYBOOK_LOCATION=$(mktemp -d -t playbook)
    trap 'rm -rf "$PLAYBOOK_LOCATION"' EXIT
    git clone -q --depth=1 "${REPOSITORY}" "$PLAYBOOK_LOCATION" || error "git clone of playbook repo failed, run with --local if already cloned"
    TARGET="$PLAYBOOK_LOCATION"
}

if [ -t 1 ]; then
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    BLUE=$(printf '\033[34m')
    RESET=$(printf '\033[m')
fi

[[ "$1" = "--local" ]] || generate_temp_dir

if [[ $(/usr/bin/gcc 2>&1) =~ "no developer tools were found" ]] || [[ ! -x /usr/bin/gcc ]];
    then
        installing "xcode"
        xcode-select --install
    else
        ok "xcode"
fi

if [[ ! -x /usr/local/bin/ansible ]];
    then
        installing "ansible"
        brew update
        brew install ansible
    else
        ok "ansible"
fi

export PATH=/usr/local/bin:$PATH

cd "$TARGET" && ansible-playbook playbook.yml -K
