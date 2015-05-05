#!/bin/sh -e

if [ "$#" -lt "2" ]; then
    echo "Not enough arguments to $(basename $0)"
    echo "Usage: $(basename $0) [data-dir] [scrap file]"
    exit 1
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

if [ "$2" = "all" ]; then
    ARGS="$1/scraps/*"
    FOCUS=false
else
    ARGS="$2"
    FOCUS=true
fi
COPY="&copy;2015 Getty Ritter (ain't no rights that ain't reserved)"

json-list -c $ARGS                      \
  | pretty-quote                        \
  | json-dict scraplist - focus $FOCUS  \
  | mustache - templates/scrap.mustache \
  | json-dict title Scraps contents - usejs true copy "$COPY" onload '"doLoadHighlight()"'  \
  | mustache - templates/main.mustache
