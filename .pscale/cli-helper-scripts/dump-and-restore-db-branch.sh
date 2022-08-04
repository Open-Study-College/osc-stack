#!/bin/bash

tmpfolder=$DIR
pscale database dump "$DB_NAME" "staging" --org "$ORG_NAME" --output $tmpfolder/tmpdir
ls -la $tmpfolder/tmpdir
pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables --org "$ORG_NAME" --dir $tmpfolder/tmpdir