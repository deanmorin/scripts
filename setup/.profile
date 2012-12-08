# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# colors for OSX
di=ex   # Directory
ln=dx   # Symbolic Link
so=dx   # Socket
pi=hx   # Pipe
ex=cx   # Executable
bd=hx   # Block (buffered) special file
cf=hx   # Character (unbuffered) special file
eu=hx   # Executable with setuid bit set
eg=hx   # Executable with setgid bit set
ds=hx   # Director writable to others, with sticky bit
dw=hx   # Director writable to others, without sticky bit
export LSCOLORS="$di$ln$so$pi$ex$bd$cf$eu$eg$ds$dw"

# aliases
alias s='source ~/.profile'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias pss='ps aux'
alias gcca='gcc -ansi -W -Wall -pedantic -g'
alias g++a='g++ -ansi -W -Wall -pedantic -g'
alias python32='sudo port select --set python python32'
alias python27='sudo port select --set python python27'
alias eclimd='/Applications/eclipse/eclimd'
alias proxy='ssh -fN -D 33033 frasier@deanmorin.me'
alias scripts='cd ~/Dropbox/scripts/'
if [[ $OSTYPE =~ [Dd]arwin ]]; then
    alias qmake='qmake -spec macx-g++'
fi
# user specific aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# path
userbin=$HOME/bin
if [[ "$(uname)" = "Darwin" ]] && [ $(which brew) ]; then
    homebrew=/usr/local/bin:/usr/local/sbin:~/Applications
    gnu="$(brew --prefix coreutils)/libexec/gnubin"
    python=/usr/local/share/python:/usr/local/share/python3
fi
export PATH=$homebrew:$gnu:$python:$userbin:$PATH

# python virtualenv variables
which yum &> /dev/null && wrapper=/usr/bin/virtualenvwrapper.sh
which aptitude &> /dev/null && wrapper=/usr/local/bin/virtualenvwrapper.sh
if which brew &> /dev/null; then
    osx_version=$(sw_vers -productVersion)
    # I think homebrew has just changed to use system versions for installed
    # packages; may not be version specific
    if vercomp $osx_version 10.7.0 '<'; then
        wrapper=/usr/local/share/python/virtualenvwrapper.sh
    else
        wrapper=/usr/local/bin/virtualenvwrapper.sh
    fi
fi
if [ -f "$wrapper" ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source "$wrapper"
    export PIP_VIRTUALENV_BASE=$WORKON_HOME
    export PIP_RESPECT_VIRTUALENV=true
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/Dropbox/scripts/setup/.bashrc" ]; then
	    . "$HOME/Dropbox/scripts/setup/.bashrc"
    fi

    # run machine specific bash preferences
    if [ -f "$HOME/.bashlocal" ]; then
        . "$HOME/.bashlocal"
    fi
fi
