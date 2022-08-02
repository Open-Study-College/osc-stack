#!/bin/bash

pscale database dump "$DB_NAME" "main" --org "$ORG_NAME"
pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables --org "$ORG_NAME" --dir "pscale_dump_osc-academic_main"