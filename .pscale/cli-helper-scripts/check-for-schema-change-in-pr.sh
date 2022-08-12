#!/bin/sh

# full paths from the repo root separated by newlines
if  git diff --name-status main..release |
  grep --quiet --line-regexp --fixed-strings "prisma/schema.prisma"
then
  echo Commit does modify schema.prisma.
  export SCHEMA_CHANGED=$SCHEMA_CHANGED
  echo "SCHEMA_CHANGED=true" >> $GITHUB_ENV
  exit 0
else
  echo Commit does not modify schema.prisma.
  export SCHEMA_CHANGED=$SCHEMA_CHANGED
  echo "SCHEMA_CHANGED=false" >> $GITHUB_ENV
  exit 0
fi