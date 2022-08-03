#!/bin/bash

tmpfolder="/tmp/main"
pscale database dump "$DB_NAME" "main" --org "$ORG_NAME" --output $tmpfolder
cp -a /tmp/* $HOME
pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables --org "$ORG_NAME" --dir $HOME