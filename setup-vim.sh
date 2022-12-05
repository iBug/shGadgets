#!/bin/sh
set -x

SRC="$1"
FILE="$2"

if [ $(id -u) -eq 0 ]; then
  TARGET=/etc/vim
else
  TARGET=$HOME/.vim
fi

for f in ftdetect ftplugin indent syntax; do
  mkdir -p "$TARGET/$f"
  wget -qO "$TARGET/$f/$FILE" "$SRC/$f/$FILE" &
done
wait
