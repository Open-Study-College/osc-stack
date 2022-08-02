#!/bin/bash
docker pull planetscale/pscale:latest
mkdir -p $HOME/.config/planetscale
alias pscale="docker run -e HOME=/tmp -v $HOME/.config/planetscale:/tmp/.config/planetscale --user $(id -u):$(id -g) --rm -it -p 3306:3306/tcp planetscale/pscale:latest"

echo "Script location: ${DIR}"
sudo pscale database dump "$DB_NAME" "main" --org "$ORG_NAME" --output "$DIR"
sudo pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables --org "$ORG_NAME" --dir "$DIR"