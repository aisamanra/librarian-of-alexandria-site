#!/bin/sh -e

if [ "$#" -lt "2" ]; then
    echo "Not enough arguments to $(basename $0)"
    echo "Usage: $(basename $0) [data-dir] [quip file]"
    exit 1
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

if [ "$2" = "all" ]; then
    ARGS="$1/quips/*"
    FOCUS=false
    OPENGRAPH="null"
else
    ARGS="$2"
    FOCUS=true
    UUID="$(basename $ARGS)"
    CONTENT="$(json-list -c $ARGS | simple-quote)"
    OPENGRAPH="$(json-dict title "quip:$UUID" url "/quips/$UUID/" description "$CONTENT")"
fi
COPY="the quips are not mine (all rights reversed)"

json-list -c $ARGS                      \
  | json-dict quotelist - focus $FOCUS  \
  | mustache - templates/quote.mustache \
  | json-dict title Quips contents - usejs true copy "$COPY" onload '"doLoadHighlight()"' opengraph "$OPENGRAPH" \
  | mustache - templates/main.mustache
