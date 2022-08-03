#!/bin/bash

tmpfolder="/var/run/main"
pscale database dump "$DB_NAME" "main" --org "$ORG_NAME" --output $tmpfolder
pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables --org "$ORG_NAME" --dir $tmpfolder