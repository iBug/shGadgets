#!/bin/sh

SRC='https://go.dev/dl'
OS=linux
ARCH=amd64
TARGET=/usr/local/go
VERSION="$(curl -s "https://go.dev/dl/?mode=json" | jq -r '.[0].version')"
CURRENT="$(go version | grep -Po 'version\s*\K\S+')"
if [ "$VERSION" = "$CURRENT" ]; then
  echo "Go version $VERSION is already up-to-date."
  exit 0
fi

URL="$SRC/$VERSION.$OS-$ARCH.tar.gz"
WORK=/tmp
TMPFILE="$WORK/go.tar.gz"

echo "Downloading go $VERSION"
wget -O "$TMPFILE" "$URL"
rm -rf "$WORK/go"
tar zxf "$TMPFILE" -C "$WORK"
rsync -av --delete "$WORK/go/" "$TARGET/"
