# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [ -x /usr/bin/tput ] && tput setaf 1 >& /dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi

# checks to see if I'm in an ssh shell (or an "s" shell if you want to be
# an annoying pedant) 
# -n checks that the string is not null
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    ssh_session=yes
else
    case $(ps -o comm= -p $PPID) 
        in sshd|*/sshd) ssh_session=yes
    esac
fi

# prompt
prompt_git()
{
    git branch &> /dev/null || return 1
    head="$(git symbolic-ref HEAD 2> /dev/null)"
    branch="${head##*/}"
    [[ -n "$(git status 2> /dev/null | grep -F 'working directory clean')" ]] \
            || status='!'
    printf "(%s)" "${status}${branch:-unknown}" 
}

prompt_svn()
{
    svn log --limit 1 &> /dev/null || return 1
    status=$(svn status 2> /dev/null | awk '{print $1}' | \
            sed -n 's;^.$;&;p' | tr '\n' ',' | sed -e 's;.$;;')
    printf "(%s)" "${status}"
}

prompt_vcs()
{
    prompt_git || prompt_svn
}

[[ "$color_prompt" = yes ]] && green='\[\e[1;32m\]' && dflt_color='\[\e[0m\]'
[[ "$ssh_session" = yes ]] && user_host='[\u@\h]'
abs_path='\w'
vcs_info="${dflt_color}\$(prompt_vcs)${green}"

export PS1="${green}${user_host}${abs_path}${vcs_info}$ ${dflt_color}"

unset abs_path
unset color_prompt
unset dflt_color
unset green
unset ssh_session
unset user_host

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias ll='ls --color=auto -l'
    alias la='ls --color=auto -a'
    alias lla='ls --color=auto -la'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
if [ "$(uname)" == Darwin ]; then
    alias ls='/bin/ls -G'
    alias ll='/bin/ls -Gl'
    alias la='/bin/ls -Ga'
    alias lla='/bin/ls -Gla'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'

# better version of cd
. ~/Dropbox/scripts/sourced_scripts/acd_func.sh

# things to be ignored by bash history
export HISTIGNORE="ls:pwd:vi:[bf]g:exit"

export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=100000                  # big big history
export HISTFILESIZE=100000              # big big history
shopt -s histappend                     # append to history, don't overwrite it

# enable multi-line command history
shopt -s cmdhist
# Save and reload the history after each command finishes
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# enable programmable completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# homebrew install bash completion
if [ -f `brew --prefix 2> /dev/null`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi
