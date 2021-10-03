#!/usr/bin/env bash
if [[ $# -ne 1 ]]; then
    echo Input file name
    exit 1
fi
pngpaste img/$1.png
echo "![$1](/img/$1.png)" | pbcopy
