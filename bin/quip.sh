#!/bin/sh

if [ "$1" = "all" ]; then
    ARGS="data/quips/*"
    FOCUS=false
else
    ARGS="$1"
    FOCUS=true
fi
COPY="the quips are not mine (all rights reversed)"

json-list -c $ARGS                      \
  | json-dict quotelist - focus $FOCUS  \
  | mustache - templates/quote.mustache \
  | json-dict title Quips contents - usejs true copy "$COPY" onload '"doLoadHighlight()"' \
  | mustache - templates/main.mustache
