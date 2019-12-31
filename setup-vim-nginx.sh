#!/bin/bash

SRC="https://github.com/nginx/nginx/raw/master/contrib/vim"
FILE="nginx.vim"

if [ $(id -u) -eq 0 ]; then
  for f in 82 81 80 74 73 72; do
    TARGET=/usr/share/vim/vim$f
    if [ -d "$TARGET" ]; then
      break;
    fi
  done
else
  TARGET=$HOME/.vim
fi

for f in ftdetect ftplugin indent syntax; do
  mkdir -p "$TARGET/$f"
  wget -qO "$TARGET/$f/$FILE" "$SRC/$f/$FILE" &
done
wait
