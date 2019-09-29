#!/bin/bash

set -e

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

ansible-playbook playbook.yml --syntax-check && ansible-playbook playbook.yml -K