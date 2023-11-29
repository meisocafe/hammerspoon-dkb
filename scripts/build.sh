#!/bin/sh

if ! which ldoc 2> /dev/null; then
    echo "Please install ldoc to continue"
    exit 1
fi

ldoc .
luarocks make meisocafe.hammerspoon.dkb-0.2-1.rockspec
