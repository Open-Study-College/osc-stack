. use-pscale-docker-image.sh
. wait-for-branch-readiness.sh

. .authenticate-ps.sh

BRANCH_NAME="$1"
DDL_STATEMENTS="$2" 

. set-db-and-org-and-branch-name.sh

. ps-create-helper-functions-pr-branches.sh
create-schema-change "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "$DDL_STATEMENTS"
create-deploy-request "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME"