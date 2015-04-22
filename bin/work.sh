#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

pandoc $1/text \
  | json-dict contents - \
  | mustache - templates/textpage.mustache \
  | json-dict title "$(cat $1/metadata.yaml | jq '.name')" contents - \
  | mustache - templates/main.mustache
