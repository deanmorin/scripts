#!/bin/bash
script_dir="$(cd "$(dirname "$0")" && pwd)"
userbin=$HOME/bin


create_symlinks() {
    for script in "$1"/*; do
        # Ignore the icon file (for OSX folder decoration)
        if [[ ! -d $script ]] && echo "$script" | grep -q -v "Icon\|README.txt"; then
            bname=$(basename "$script")
            extensionless="${bname%.*}"
            symlink=$userbin/$extensionless
            { [[ -L $symlink ]] && rm "$symlink"; } || echo $extensionless
            ln -s $script $symlink
        fi
    done
}


[[ ! -d $userbin ]] && mkdir $userbin

echo "> Creating script symlinks"
create_symlinks "$script_dir"

if [[ $1 = "-w" ]] || [[ $1 = "--work" ]]; then
    echo "> Creating work script symlinks"
    create_symlinks "$script_dir/work_scripts"
fi
