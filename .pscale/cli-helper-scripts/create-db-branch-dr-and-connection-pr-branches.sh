#!/bin/bash

. .pscale/cli-helper-scripts/use-pscale-docker-image.sh
. .pscale/cli-helper-scripts/wait-for-branch-readiness.sh

. .pscale/cli-helper-scripts/authenticate-ps.sh

BRANCH_NAME="$1"
DDL_STATEMENTS="$2" 

. .pscale/cli-helper-scripts/set-db-and-org-and-branch-name.sh


. .pscale/cli-helper-scripts/create-branch-connection-string-pr-branches.sh
create-branch-connection-string "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "testcred"
    # if $2 and $3 are set, generate secret output links
    if [ -n "$2" ] && [ -n "$3" ]; then
        for i in `seq 1 $2`; do
            for j in `seq 1 $3`; do
                echo "::set-output name=dbconnection_${i}_${j}::`curl -s -X POST -d "plain&secret=$MY_DB_URL" https://shared-secrets-planetscale.herokuapp.com/`"          
            done
        done
    fi

. .pscale/cli-helper-scripts/dump-and-restore-db-branch.sh "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "$DIR"