#!/bin/bash

set -e

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

command_exists git || {
		error "git is not installed"
		exit 1
  }

git clone --depth=1 https://github.com/pivovarit/mac-os-playbook || {
		error "git clone of oh-my-zsh repo failed"
		exit 1
	}

if [[ $(/usr/bin/gcc 2>&1) =~ "no developer tools were found" ]] || [[ ! -x /usr/bin/gcc ]];
    then
        echo "Info   | Install   | xcode"
        xcode-select --install
    else
        echo "Info   | OK        | xcode"
fi

if [[ ! -x /usr/local/bin/ansible ]];
    then
        echo "Info   | Install   | ansible"
        brew update
        brew install ansible
    else
        echo "Info   | OK        | ansible"
fi

export PATH=/usr/local/bin:$PATH

cd mac-os-playbook

ansible-playbook playbook.yml -K