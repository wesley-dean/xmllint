#!/usr/bin/env bash

shopt -s globstar
shopt -s nullglob

PATTERN="${PATTERN:-**/*.xml}"

result=0

for filename in ${PATTERN} ; do
  echo "$filename"
  xmllint "$@" "$filename" || result=1
done

exit $result
