#!/bin/sh

# full paths from the repo root separated by newlines
if  git diff --name-status main..release |
  grep --quiet --line-regexp --fixed-strings "prisma/schema.prisma"
then
  echo Commit does modify schema.prisma.
  export SCHEMA_CHANGED=$SCHEMA_CHANGED
  exit 0
else
  echo Commit does not modify schema.prisma.
  export SCHEMA_CHANGED=$SCHEMA_CHANGED
  exit 0
fi