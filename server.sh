#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $SCRIPT_DIR

if type miniserve &> /dev/null; then
  MINISERVE="miniserve"
else
  MINISERVE="$SCRIPT_DIR/resources/miniserve/miniserve"
fi

"$MINISERVE" "$SCRIPT_DIR/export/web" --index "index.html"
