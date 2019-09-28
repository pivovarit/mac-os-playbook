#!/bin/bash

set -e

if [[ $(/usr/bin/gcc 2>&1) =~ "no developer tools were found" ]] || [[ ! -x /usr/bin/gcc ]]; then
    echo "Info   | Install   | xcode"
    xcode-select --install
fi

if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Info   | Install   | homebrew"
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

if [[ ! -x /usr/local/bin/ansible ]]; then
    echo "Info   | Install   | Ansible"
    brew update
    brew install ansible
fi

export PATH=/usr/local/bin:$PATH