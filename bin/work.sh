#!/bin/sh -e

if [ "$#" -lt "2" ]; then
    echo "Not enough arguments to $(basename $0)"
    echo "Usage: $(basename $0) [data-dir] [work-dir]"
    exit 1
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATH=$DIR:$PATH

markdown_py2 -x markdown.extensions.footnotes $2/text \
  | json-dict contents - \
  | mustache - templates/textpage.mustache \
  | json-dict title "$(cat $2/metadata.yaml | jq '.name')" contents - \
  | mustache - templates/main.mustache
