mkdir "./pscale_dump_\"$DB_NAME\"_\"$BRANCH_NAME\""
pscale database dump "$DB_NAME" "main" --org "$ORG_NAME"
pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables --org "$ORG_NAME" --dir "./pscale_dump_\"$DB_NAME\"_\"$BRANCH_NAME\""