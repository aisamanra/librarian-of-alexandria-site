#!/bin/sh -e

if [ "$#" -lt "2" ]; then
    echo "Not enough arguments to $(basename $0)"
    echo "Usage: $(basename $0) [data-dir] [category-name]"
    exit 1
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

SLUG=$(basename $2)
NAME=$(cat $1/works.json | jq ".[] | select(.slug == \"$SLUG\").category")
if [ "x$NAME" = "x" ]; then
    echo "Unable to find category: $1" >&2
    exit 1
fi

json-list -c $2/*/metadata.yaml \
  | json-dict works - \
  | mustache - templates/list.mustache \
  | json-dict title $NAME contents - \
  | mustache - templates/main.mustache
