pscale database dump "$DB_NAME" "main"
pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables