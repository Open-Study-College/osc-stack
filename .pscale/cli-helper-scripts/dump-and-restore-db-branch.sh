#!/bin/bash

tmpfolder="/run/main"
pscale database dump "$DB_NAME" "main" --org "$ORG_NAME" --output $tmpfolder
cp -v -a /run/* $HOME
pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables --org "$ORG_NAME" --dir $HOME