#!/usr/bin/env bash
# mostly copied from:
# http://stackoverflow.com/questions/4023830/bash-how-compare-two-strings-in-version-format

vercomp() {
    if [[ $1 == $2 ]]
        then
            return 0
        fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

[ -z "$3" ] && echo '> usage: ver1 ver2 comparison_operator' && exit 1
vercomp $1 $2
case $? in
    0) op='=';;
    1) op='>';;
    2) op='<';;
esac
[[ $op != $3 ]] && exit 2
exit 0
