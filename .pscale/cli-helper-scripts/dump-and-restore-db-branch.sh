#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "Script location: ${DIR}"
pscale database dump "$DB_NAME" "main" --org "$ORG_NAME" --output "$DIR"
pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables --org "$ORG_NAME" --dir "$DIR/pscale_dump_osc-academic_main"