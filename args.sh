#!/bin/bash
# save as args.sh, run: ./args.sh "hello world" foo bar

echo "--- Using \"\$@\" ---"
for arg in "$@"; do
  echo "[$arg]"
done

echo "--- Using \"\$*\" ---"
for arg in "$*"; do
  echo "[$arg]"
done

