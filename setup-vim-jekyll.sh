#!/bin/bash
set -x

TMP=/tmp
SRC="https://github.com/tpope/vim-liquid/archive/master.tar.gz"
DIR=vim-liquid-master
FILE=liquid.vim

if [ $(id -u) -eq 0 ]; then
  if [ -d /etc/vim ]; then
    TARGET=/etc/vim
  else
    for f in 72 73 74 80 81; do
      TARGET=/usr/share/vim/vim$f
      if [ -d "$TARGET" ]; then
        break;
      fi
    done
  fi
else
  TARGET=$HOME/.vim
fi

trap 'rm -rf "$TMP/master.tar.gz" "$TMP/$DIR"' EXIT
wget -qO $TMP/master.tar.gz "$SRC" >/dev/null || exit 1
tar zxf $TMP/master.tar.gz -C $TMP
for f in ftdetect ftplugin indent syntax; do
  mkdir -p "$TARGET/$f"
  mv "$TMP/$DIR/$f/$FILE" "$TARGET/$f/"
done
