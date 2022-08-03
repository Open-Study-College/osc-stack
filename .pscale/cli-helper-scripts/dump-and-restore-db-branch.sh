#!/bin/bash

echo "Script location: ${DIR}"
pscale database dump "$DB_NAME" "main" --org "$ORG_NAME" --output "/tmp/main"

search_dir=/tmp/main
for entry in "$search_dir/*"
do
  echo "$entry"
done

pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables --org "$ORG_NAME" --dir "/tmp/main"