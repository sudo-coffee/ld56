#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $SCRIPT_DIR

"$SCRIPT_DIR/resources/miniserve/miniserve" \
  "$SCRIPT_DIR/export/web" \
  --index "index.html"
