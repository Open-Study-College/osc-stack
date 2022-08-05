#!/bin/bash

. use-pscale-docker-image.sh
. authenticate-ps.sh
. wait-for-deploy-request-merged.sh
. set-db-and-org-and-branch-name.sh
. ps-create-helper-functions-pr-branches.sh
create-deployment "$DB_NAME" "$ORG_NAME" "$DEPLOY_REQUEST_NUMBER"