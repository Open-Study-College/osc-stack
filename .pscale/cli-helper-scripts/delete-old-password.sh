function create-branch-connection-string {
    local DB_NAME=$1
    local BRANCH_NAME=$2
    local ORG_NAME=$3
    local CREDS=${4,,}-PR-$(uuidgen)
    local secretshare=$5

    # delete password if it already existed
    # first, list password if it exists
    local raw_output=`pscale password list "$DB_NAME" "$BRANCH_NAME" --org "$ORG_NAME" --format json `
    # check return code, if not 0 then error
    if [ $? -ne 0 ]; then
        echo "Error: pscale password list returned non-zero exit code $?: $raw_output"
        exit 1
    fi

    local output=`echo $raw_output | jq -r "[.[] | select(.display_name.startswith(\"$CREDS\"-PR-)) ] | .[1].id "`
    # if output is not "null", then password exists, delete it
    if [ "$output" != "null" ]; then
        echo "Deleting existing password $output"
        pscale password delete --force "$DB_NAME" "$BRANCH_NAME" "$output" --org "$ORG_NAME"
        # check return code, if not 0 then error
        if [ $? -ne 0 ]; then
            echo "Error: pscale password delete returned non-zero exit code $?"
            exit 1
        fi
    fi
}


. .pscale/cli-helper-scripts/use-pscale-docker-image.sh
. .pscale/cli-helper-scripts/wait-for-branch-readiness.sh

. .pscale/cli-helper-scripts/authenticate-ps.sh

create-branch-connection-string "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "${BRANCH_NAME}" 
    # if $2 and $3 are set, generate secret output links
    if [ -n "$2" ] && [ -n "$3" ]; then
        for i in `seq 1 $2`; do
            for j in `seq 1 $3`; do
                echo "::set-output name=dbconnection_${i}_${j}::`curl -s -X POST -d "plain&secret=$MY_DB_URL_MAIN" https://shared-secrets-planetscale.herokuapp.com/`"          
            done
        done
    fi