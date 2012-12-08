#!/bin/bash

function error_check(){
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit
    fi
}

function update_plugin(){
    echo ">>> Grabbing the latest version of $1..."
    cd $DIR/bundle/$1
    git pull origin master
}

echo "> Updating vim configuration"

if [ $OSTYPE = "msys" ]; then
    # Windows
    DIR=~/vimfiles
    SOURCE_DIR=$(echo $DIR | awk '{sub("/c/","C:/")}1')
    VIMRC="_vimrc"
    GIT_REMOTE="git@github.com:deanmorin/.vim.git vimfiles"
else
    DIR=~/.vim
    SOURCE_DIR=$DIR
    VIMRC=".vimrc"
    GIT_REMOTE="git@github.com:deanmorin/.vim.git"
fi

if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
fi
if [ ! -f ~/.ssh/id_rsa ]; then
    cd ~/.ssh
    ssh-keygen -t rsa -C "morin.dean@gmail.com"
    echo ">>> Add the public key to github, then rerun this script."
    exit
fi


if [ ! -f $DIR/README ]; then
    # my vim settings are not installed on this machine, set up git repo
    cd
    git clone $GIT_REMOTE
    error_check "Something's wrong with Git..."

    echo "\" To make any changes to the vimrc, change $DIR/$VIMRC" > ~/$VIMRC 
    echo "set runtimepath+=$SOURCE_DIR" >> ~/$VIMRC
    echo "source $SOURCE_DIR/.vimrc" >> ~/$VIMRC
    mkdir $DIR/undodir

else
    # git repository exists, need push changes to remote
    cd $DIR
    git add -p
    git commit
    git pull origin master
    git push origin master
    git status
fi

vi "+Helptags" "+q"

# upgrade plugins if option set (avoid directly upgrading on Windows)
if [ "$1" == "-u" -o "$1" == "--update" ] && [ $OSTYPE != "msys" ]; then
    echo ">>> Grabbing the latest version of pathogen..."
    curl &> /dev/null
    if [ $? -ne 127 ]; then
        curl 'www.vim.org/scripts/download_script.php?src_id=16224' > $DIR/autoload/pathogen.vim
    fi
    update_plugin YankRing.vim
    update_plugin a.vim
    #update_plugin greplace.vim
    #update_plugin gundo.vim
    #update_plugin nerdcommenter
    #update_plugin nerdtree
    update_plugin syntastic
    update_plugin tagbar
    update_plugin vim-repeat
    update_plugin vim-speeddating
    update_plugin vim-surround
fi
