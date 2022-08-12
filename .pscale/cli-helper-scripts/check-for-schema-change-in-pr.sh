#!/bin/sh

# full paths from the repo root separated by newlines
MUST_NOT_CHANGE='prisma/schema.prisma
'

BRANCH="$(git rev-parse --abbrev-ref HEAD)"

echo $BRANCH
if git diff --cached --name-only $against |
  grep --quiet --line-regexp --fixed-strings "$MUST_NOT_CHANGE"
then
  echo Commit does modify schema.prisma.
  echo "SCHEMA_CHANGED=true" >> $GITHUB_ENV
  export SCHEMA_CHANGED=$SCHEMA_CHANGED
  exit 0
else
  echo Commit does not modify schema.prisma.
  echo "SCHEMA_CHANGED=false" >> $GITHUB_ENV
  export SCHEMA_CHANGED=$SCHEMA_CHANGED
  exit 0
fi