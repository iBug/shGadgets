#!/bin/sh

set -e -u

SU=""
if [ "$(id -u)" != 0 ]; then SU="sudo "; fi

show_help(){
cat<<%
Usage: ${SU}pkg command [arguments]

A wrapper for apt(8) and apt-get(8)

Commands:
  h     show this help (also [empty])
  i     install packages
  l     list packages
  li    list installed packages
  lu    list upgradable packages
  r     remove packages
  ar    auto-remove packages
  u     update and upgrade
  U     update only
  fu    full upgrade (no update)
  m     show package info
  s     search
  f     list files for installed packages
%
}

if [ $# -eq 0 ]; then show_help; exit; fi
CMD="$1"
shift

case "$CMD" in
  h) show_help;;
  i) apt install $@;;
  l) apt list $@;;
  li) apt list --installed $@;;
  lu) apt list --upgradable $@;;
  r) apt remove $@;;
  ar) apt autoremove $@;;
  u) apt update && apt upgrade;;
  U) apt update;;
  fu) apt full-upgrade;;
  m) apt show $@;;
  s) apt search $@;;
  f) dpkg -L $@;;
  *) echo "Unknown command: $CMD"; exit 1;;
esac
