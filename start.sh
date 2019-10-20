#!/bin/bash

set -e

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

exists() {
	command -v "$@" >/dev/null 2>&1
}

if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		BLUE=$(printf '\033[34m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		BLUE=""
		RESET=""
fi

exists git || error "git is not installed"

TARGET="$(pwd)"

if [ "x$1" != "x--local" ]
    then
      git clone -q --depth=1 https://github.com/pivovarit/mac-os-playbook || error "git clone of oh-my-zsh repo failed, run with --local if already cloned"
	    TARGET='mac-os-playbook/'
fi

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

cd $TARGET && ansible-playbook playbook.yml -K