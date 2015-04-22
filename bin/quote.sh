#!/bin/sh

if [ "$1" = "all" ]; then
    ARGS="data/quotes/*"
    FOCUS=false
else
    ARGS="$1"
    FOCUS=true
fi
COPY="all quotes used under fair use &c &c"

json-list -c $ARGS                      \
  | json-dict quotelist - focus $FOCUS  \
  | mustache - templates/quote.mustache \
  | json-dict title Quotes contents - usejs true copy "$COPY" onload '"doLoadHighlight()"'  \
  | mustache - templates/main.mustache
