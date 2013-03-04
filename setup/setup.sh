#!/usr/bin/env bash

dropbox=~/Dropbox

# show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles TRUE
# set which apps to open each file type with
mv "$dropbox/dotfiles/com.apple.LaunchServices.plist" ~/Library/Preferences

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
~/bin/myvim

mkdir ~/.virtualenvs &>/dev/null
