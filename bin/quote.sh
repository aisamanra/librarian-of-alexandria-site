#!/bin/sh -e

if [ "$#" -lt "2" ]; then
    echo "Not enough arguments to $(basename $0)"
    echo "Usage: $(basename $0) [data-dir] [quote file]"
    exit 1
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

if [ "$2" = "all" ]; then
    ARGS="$1/quotes/*"
    FOCUS=false
    OPENGRAPH="null"
else
    ARGS="$2"
    FOCUS=true
    UUID="$(basename $ARGS)"
    CONTENT="$(json-list -c $ARGS | simple-quote)"
    OPENGRAPH="$(json-dict title "quote:$UUID" url "/quote/$UUID/" description "$CONTENT")"
fi
COPY="all quotes used under fair use &c &c"

json-list -c $ARGS                      \
  | pretty-quote                        \
  | json-dict quotelist - focus $FOCUS  \
  | mustache - templates/quote.mustache \
  | json-dict title Quotes contents - usejs true copy "$COPY" onload '"doLoadHighlight()"' opengraph "$OPENGRAPH"  \
  | mustache - templates/main.mustache
