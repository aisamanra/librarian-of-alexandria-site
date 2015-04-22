#!/bin/sh -e

if [ "$#" -lt "1" ]; then
    echo "Not enough arguments to $(basename $0)"
    echo "Usage: $(basename $0) [data-dir]"
    exit 1
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

cat $1/works.json \
  | jq '[.[] | { slug: ("category/" + .slug), name: .category }]' \
  | json-dict works - \
  | mustache - templates/list.mustache \
  | json-dict title 'Permanent Collections' contents - \
  | mustache - templates/main.mustache
