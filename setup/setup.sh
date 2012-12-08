#!/usr/bin/env bash

dropbox=~/Dropbox

if [ ! -d $dropbox ]; then
    echo "> Install Dropbox before continuing"
    exit
fi

which git &>/dev/null
if [ $? -ne 0 ]; then
    echo "> Install git before continuing"
    exit
fi

"$dropbox/dotfiles/symlink.sh"
"$dropbox/scripts/symlink.sh" "$1"
myvim

mkdir ~/.virtualenvs &>/dev/null
