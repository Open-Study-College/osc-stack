function delete-branch-connection-string {
    local DB_NAME=$1
    local BRANCH_NAME=$2
    local ORG_NAME=$3
    local CREDS=${4,,}-cicd-
    local secretshare=$5

    # delete password if it already existed
    # first, list password if it exists
    local raw_output=`pscale password list "$DB_NAME" "$BRANCH_NAME" --org "$ORG_NAME" --format json `
    # check return code, if not 0 then error
    if [ $? -ne 0 ]; then
        echo "Error: pscale password list returned non-zero exit code $?: $raw_output"
        exit 1
    fi

    local output=`echo $raw_output | jq -r -c "[.[] | select(.display_name | startswith(\"$CREDS\")) ]"`
    # if output is not "null", then password exists, delete it

    for row in $(echo "${output}" | jq -r '.[] | @base64'); do
        echo "$output"
        local password = `echo $row jq -r -c "[.[] | .[0].id ]"`
        echo "$password"
        if [ "$output" != "null" ]; then
            echo "Deleting existing password $password"
            pscale password delete --force "$DB_NAME" "$BRANCH_NAME" "$password" --org "$ORG_NAME"
            # check return code, if not 0 then error
            if [ $? -ne 0 ]; then
                echo "Error: pscale password delete returned non-zero exit code $?"
                exit 1
            fi
        fi
    done
}


. .pscale/cli-helper-scripts/use-pscale-docker-image.sh
. .pscale/cli-helper-scripts/wait-for-branch-readiness.sh

. .pscale/cli-helper-scripts/authenticate-ps.sh

delete-branch-connection-string "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "${BRANCH_NAME}" 