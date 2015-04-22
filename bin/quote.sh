#!/bin/sh -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

if [ "$2" = "all" ]; then
    ARGS="$1/quotes/*"
    FOCUS=false
else
    ARGS="$2"
    FOCUS=true
fi
COPY="all quotes used under fair use &c &c"

json-list -c $ARGS                      \
  | pretty-quote                        \
  | json-dict quotelist - focus $FOCUS  \
  | mustache - templates/quote.mustache \
  | json-dict title Quotes contents - usejs true copy "$COPY" onload '"doLoadHighlight()"'  \
  | mustache - templates/main.mustache
