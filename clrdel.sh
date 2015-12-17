#!/usr/bin/env bash
# deletes (permanently) everything in the .deleted folder
set -e

echo -n "> Empty the .deleted folder? (y/n) "
read choice
if [[ $choice = y ]]; then
    [[ -d ~/.deleted ]] || exit
    cd ~/.deleted
    rm -rf "$(ls -A ~/.deleted/)"
    cd - &> /dev/null
    echo "> '.deleted' has been cleared."
fi
