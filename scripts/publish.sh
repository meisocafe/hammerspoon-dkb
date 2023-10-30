#!/bin/sh

if [ "$1" = "" ]; then
  echo "Provide a rocksfile as an argument"
  exit
fi

luarocks upload "$1" --api-key="$LUAROCKS_API_KEY"
