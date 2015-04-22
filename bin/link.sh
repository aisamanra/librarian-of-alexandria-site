#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

if [ "$2" = "all" ]; then
    ARGS="$1/links/*"
    FOCUS=false
else
    ARGS="$2"
    FOCUS=true
fi
COPY="whaa"

json-list -c $ARGS                     \
  | json-dict linklist - focus $FOCUS  \
  | mustache - templates/link.mustache \
  | json-dict title Link contents - usejs true copy "$COPY" onload '"doLoadHighlight()"' \
  | mustache - templates/main.mustache
