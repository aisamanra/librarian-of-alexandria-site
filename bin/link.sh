#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

if [ "$1" = "all" ]; then
    ARGS="data/links/*"
    FOCUS=false
else
    ARGS="$1"
    FOCUS=true
fi
COPY="whaa"

json-list -c $ARGS                     \
  | json-dict linklist - focus $FOCUS  \
  | mustache - templates/link.mustache \
  | json-dict title Link contents - usejs true copy "$COPY" onload '"doLoadHighlight()"' \
  | mustache - templates/main.mustache
