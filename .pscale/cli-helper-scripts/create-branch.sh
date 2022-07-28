#!/bin/bash

. use-pscale-docker-image.sh
. wait-for-branch-readiness.sh

. authenticate-ps.sh

BRANCH_NAME="$1"

. ps-create-helper-functions.sh
echo "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME"
create-db-branch "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME"