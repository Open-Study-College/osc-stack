#!/bin/bash

DB_NAME="$1"
ORG_NAME="$2" 
DEPLOY_REQUEST_NUMBER="$3" 

. .pscale/cli-helper-scripts/wait-for-deploy-request-merged.sh 9 "$DB_NAME" "$DEPLOY_REQUEST_NUMBER" "$ORG_NAME" 60
. .pscale/cli-helper-scripts/set-db-and-org-and-branch-name.sh
. .pscale/cli-helper-scripts/ps-create-helper-functions-pr-branches.sh
create-deployment "$DB_NAME" "$ORG_NAME" "$DEPLOY_REQUEST_NUMBER"