#!/bin/bash

# Requires CairoSVG

if [ $# -eq 0 ]; then
  exit 1
fi

# Defaults
WIDTH=512

while getopts ":w:" OPT; do
  case "$OPT" in
    w) WIDTH="$OPTARG";;
    :) echo >&2 "Option $OPTARG requires an argument."; exit 1;;
    *) ;;
  esac
done

shift $((OPTIND - 1))

HEIGHT="$WIDTH"

while [ $# -gt 0 ]; do
  INPUT="$1"
  shift
  if ! [[ $INPUT =~ \.svg$ ]]; then
    continue
  fi
  OUTPUT="${INPUT%.*}.png"
  cairosvg --output-width "$WIDTH" --output-height "$HEIGHT" -o "$OUTPUT" "$INPUT"
done
