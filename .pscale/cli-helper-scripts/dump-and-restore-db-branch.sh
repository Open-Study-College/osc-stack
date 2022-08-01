local DB_NAME=$1
local BRANCH_NAME=$2
local ORG_NAME=$3
local recreate_branch=$4

pscale database dump "$DB_NAME" "main"
pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables