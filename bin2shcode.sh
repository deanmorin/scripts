#!/bin/bash

# prints the shell code for the given binary (it's not perfect)

if [ -z "$1" ]; then
    echo "usage $0 <binary>"
    exit
fi
bin="$1"

objdump -d $bin \
    | sed -n 's;^\s*[0-9a-f]*:\s*\([0-9a-f]*\);\1;p' \
    | sed -e 's;[0-9a-f]\{2\}\s;\\x&;g' \
          -e 's;\s\{2\}.*;;' \
    | tr -d ' \n' \
    | sed '1s;.\{60\};char code[] = "&"\\\n;' \
    | sed '2,$s;.\{60\};              "&"\\\n;g' \
    | sed '$s;^.*[^\\]$;              "&"\\\n;g' \
    | sed '$s;\\$;\;;'
