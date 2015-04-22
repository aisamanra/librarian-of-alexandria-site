#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

if [ "$2" = "all" ]; then
    ARGS="$1/quips/*"
    FOCUS=false
else
    ARGS="$2"
    FOCUS=true
fi
COPY="the quips are not mine (all rights reversed)"

json-list -c $ARGS                      \
  | json-dict quotelist - focus $FOCUS  \
  | mustache - templates/quote.mustache \
  | json-dict title Quips contents - usejs true copy "$COPY" onload '"doLoadHighlight()"' \
  | mustache - templates/main.mustache
