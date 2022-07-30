#!/bin/bash

. use-pscale-docker-image.sh
. wait-for-branch-readiness.sh

. authenticate-ps.sh

DB_NAME="$1"
BRANCH_NAME="$2" 
ORG_NAME="$3"
CREDS= "$4"
DDL_STATEMENTS="$5"


. ps-create-helper-functions.sh
create-db-branch "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "recreate"
create-schema-change "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "$DDL_STATEMENTS"
create-deploy-request "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME"


. create-branch-connection-string.sh
create-branch-connection-string "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "$CREDS" "$DDL_STATEMENTS"

