#!/bin/bash

. .pscale/cli-helper-scripts/use-pscale-docker-image.sh
. .pscale/cli-helper-scripts/wait-for-branch-readiness.sh

. .pscale/cli-helper-scripts/authenticate-ps.sh

BRANCH_NAME="$1"
DDL_STATEMENTS="$2" 

. .pscale/cli-helper-scripts/set-db-and-org-and-branch-name.sh

. .pscale/cli-helper-scripts/ps-create-helper-functions-pr-branches.sh
create-db-branch "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "recreate" "$FROM"

. .pscale/cli-helper-scripts/create-branch-connection-string-pr-branches.sh

. .pscale/cli-helper-scripts/dump-and-restore-db-branch.sh "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "$DIR"