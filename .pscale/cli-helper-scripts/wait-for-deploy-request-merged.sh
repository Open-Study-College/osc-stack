function wait_for_deploy_request_merged {
    local retries=$1
    local DB_NAME=$2
    local DEPLOY_REQUEST_NUMBER=$3
    local ORG_NAME=$4
    
    # check whether fifth parameter is set, otherwise use default value
    if [ -z "$5" ]; then
        local max_timeout=600
    else
        local max_timeout=$5
    fi

    local count=0
    local wait=1

    echo "Checking if deploy request $DEPLOY_REQUEST_NUMBER is ready for use..."
    while true; do
        local raw_output=`pscale deploy-request list "$DB_NAME" --org "$ORG_NAME" --format json`
        # check return code, if not 0 then error
        if [ $? -ne 0 ]; then
            echo "Error: pscale deploy-request list returned non-zero exit code $?: $raw_output"
            return 1
        fi
        local output=`echo $raw_output | jq ".[] | select(.number == $DEPLOY_REQUEST_NUMBER) | .deployment.state"`
        # test whether output is pending, if so, increase wait timeout exponentially
        if [ "$output" = "\"pending\"" ] || [ "$output" = "\"in_progress\"" ]; then
            # increase wait variable exponentially but only if it is less than max_timeout
            if [ $((wait * 2)) -le $max_timeout ]; then
                wait=$((wait * 2))
            else
                wait=$max_timeout
            fi  

            count=$((count+1))
            if [ $count -ge $retries ]; then
                echo  "Deploy request $DEPLOY_REQUEST_NUMBER is not ready after $retries retries. Exiting..."
                return 2
            fi
            echo  "Deploy-request $DEPLOY_REQUEST_NUMBER is not deployed yet. Current status:"
            echo "show vitess_migrations\G" | pscale shell "$DB_NAME" main --org "$ORG_NAME"
            echo "Retrying in $wait seconds..."
            sleep $wait
        elif [ "$output" = "\"complete\"" ] || [ "$output" = "\"complete_pending_revert\"" ]; then
            echo  "Deploy-request $DEPLOY_REQUEST_NUMBER has been deployed successfully."
            return 0
        else
            echo  "Deploy-request $DEPLOY_REQUEST_NUMBER with unknown status: $output"
            return 3
        fi
    done
}
