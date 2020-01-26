#!/bin/sh

help() {
  echo "Usage: $0 <URL>"
  echo "  Downloads a list from downloads.khinsider.com"
  echo "  Requires Wget, cURL and \`grep -P\`"
}

if [ $# -eq 0 ]; then
  help
  exit 1
fi

URL="$1"

for item in $(curl -fsSL "$URL" | grep -Po '(?<=<a href="/)\S+\.mp3(?="><i)'); do
  item="https://downloads.khinsider.com/$item"
  echo "Getting \"$item\""
  newUrl="$(curl -fsSL "$item" | grep -Po '(?<= href=")\S+\.mp3(?=">)')"
  echo "URL: $newUrl"
  wget -nv -N "$newUrl" &
done
wait
