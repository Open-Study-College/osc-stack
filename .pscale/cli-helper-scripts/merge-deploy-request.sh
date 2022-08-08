#!/bin/bash

. .pscale/cli-helper-scripts/use-pscale-docker-image.sh
. .pscale/cli-helper-scripts/authenticate-ps.sh
. .pscale/cli-helper-scripts/wait-for-deploy-request-merged.sh 9 "$DB_NAME" "$DEPLOY_REQUEST_NUMBER" "$ORG_NAME" 60
. .pscale/cli-helper-scripts/set-db-and-org-and-branch-name.sh
. .pscale/cli-helper-scripts/ps-create-helper-functions-pr-branches.sh
create-deployment "$DB_NAME" "$ORG_NAME" "$DEPLOY_REQUEST_NUMBER"