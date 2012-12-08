#!/bin/bash
# "deletes" files safely by moving them to ~/.deleted

if [ ! -d ~/.deleted ]; then
	mkdir ~/.deleted
fi

if [ ! -f ~/.deleted/.log ]; then
	touch ~/.deleted/.log
fi

if [ "$1" == "-q" ]; then
    quiet=yes
    shift
fi

while (( "$#" )); do
    count=1
    
    if [ -L "$1" ]; then
        # file is a symlink
        rm $1
        if [ "$quiet" != yes ]; then
            echo "> $1 (symlink)"
        fi

	elif [ -d "$1" ] || [ -f "$1" ]; then
        full_path=$(pwd)/$1
        name=$(basename $1)
        # append a number to the filename if a file with that name already 
        # exists in the .deleted folder
        while [ -d ~/.deleted/"$name" ] || [ -f ~/.deleted/"$name" ]; do
            name="$(basename "$1")($count)"
            count=$(($count + 1)) 
        done

        # display the file that's being deleted
        if [ "$quiet" != yes ]; then
            if [ -d "$1" ] && [[ "$1" != */ ]]; then
                echo "> $1/"
            else
                echo "> $1"
            fi
        fi

        # "delete" the file
        mv -f "$1" ~/.deleted/"$name"
        if [ "$?" -ne "0" ]; then
            echo "Could not delete $1"
            exit 1
        fi
        # log the newly deleted file
        echo "$full_path - $(date)" >> ~/.deleted/.log

	else
		echo "'$1' does not exist"
        exit
	fi

	shift

done
