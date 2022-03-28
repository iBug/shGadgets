#!/bin/sh

F=package/package.json
TMP=/tmp/package.json

jq 'del(.homepage, .bugs, .author, .contributors, .repository) | .name = "fapro-free"' "$F" > "$TMP"
cat "$TMP" > "$F"
