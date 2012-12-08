#!/bin/bash

dropbox=$HOME/Dropbox
userbin=$HOME/bin

function create_symlinks()
{
    for script in "$1"/*; do
        # Ignore the icon file (for OSX folder decoration)
        if [[ ! -d $script ]] && echo "$script" | grep -q -v "Icon"; then
            bname=$(basename "$script")
            extensionless="${bname%.*}"
            [[ -L $userbin/$extensionless ]] && rm "$userbin/$extensionless"
            ln -s $script $userbin/$extensionless
        fi
    done
}

[[ ! -d $userbin ]] && mkdir $userbin

echo "> Creating script symlinks"
create_symlinks "$dropbox/scripts"

if [[ $1 = "-w" ]] || [[ $1 = "--work" ]]; then
    echo "> Creating work script symlinks"
    create_symlinks "$dropbox/scripts/work_scripts"
fi
