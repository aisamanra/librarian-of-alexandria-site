#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

cat $1/works.json \
  | jq '[.[] | { slug: ("category/" + .slug), name: .category }]' \
  | json-dict works - \
  | mustache - templates/worklist.mustache \
  | json-dict title 'Permanent Collections' contents - \
  | mustache - templates/main.mustache
