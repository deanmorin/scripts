#!/bin/bash
# deletes (permanently) everything in the .deleted folder

echo -n "> Empty the .deleted folder? (y/n) "
read choice
if [ $choice = y ]; then
    cd ~/.deleted
    rm -rf $(ls -A ~/.deleted/)
    cd - &> /dev/null
	echo "> '.deleted' has been cleared."
fi
