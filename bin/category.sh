#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

SLUG=$(basename $1)
NAME=$(cat data/works.json | jq ".[] | select(.slug == \"$SLUG\").category")
if [ "x$NAME" = "x" ]; then
	echo "Unable to find category: $1" >&2
	exit 1
fi

json-list -c $1/*/metadata.yaml \
  | json-dict works - \
  | mustache - templates/worklist.mustache \
  | json-dict title $NAME contents - \
  | mustache - templates/main.mustache
