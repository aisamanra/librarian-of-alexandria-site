#!/bin/sh

pandoc $1/text \
  | mustache - templates/textpage.mustache
  | json-dict title "$(cat $1/metadata.yaml | jq '.name')" contents - \
  | mustache - templates/main.mustache
