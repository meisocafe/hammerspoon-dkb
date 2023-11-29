#!/bin/sh
#
# Before publishing, tag your commit with vX.X-X and push both the commit and the tag to github

if [ "$1" = "" ]; then
    echo "Provide a rocksfile as an argument"
    exit
fi

luarocks upload "$1" --api-key="$LUAROCKS_API_KEY"
