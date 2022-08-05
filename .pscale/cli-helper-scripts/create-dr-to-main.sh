. .pscale/cli-helper-scripts/use-pscale-docker-image.sh
. .pscale/cli-helper-scripts/wait-for-branch-readiness.sh

. .pscale/cli-helper-scripts/authenticate-ps.sh

BRANCH_NAME="$1"
DDL_STATEMENTS="$2" 

. .pscale/cli-helper-scripts/set-db-and-org-and-branch-name.sh

. .pscale/cli-helper-scripts/ps-create-helper-functions-pr-branches.sh
create-schema-change "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "$DDL_STATEMENTS"
create-deploy-request "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME"