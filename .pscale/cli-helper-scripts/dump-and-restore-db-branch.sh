#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "Script location: ${DIR}"
pscale database dump "$DB_NAME" "main" --org "$ORG_NAME" --output "../../pscale_dump_osc-academic_main"
pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables --org "$ORG_NAME" --dir "../../pscale_dump_osc-academic_main"