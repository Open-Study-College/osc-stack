#!/bin/sh

if git rev-parse --verify HEAD >/dev/null 2>&1
then
  against=HEAD
else
  # Initial commit: diff against an empty tree object
  against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

exec 1>&2

if git diff --cached --name-only $against |
   grep --quiet --line-regexp --fixed-strings "$MUST_NOT_CHANGE"
then
  echo Commit would modify schema.prisma, use a db branch instead.
  exit 1
else
  exit 0
fi
fi

if [[ "$BRANCH" != Db* ]] ; then
echo $BRANCH
if git rev-parse --verify HEAD >/dev/null 2>&1
then
  against=HEAD
else
  # Initial commit: diff against an empty tree object
  against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

exec 1>&2

if git diff --cached --name-only $against |
   grep --quiet --line-regexp --fixed-strings "$MUST_NOT_CHANGE"
then
  echo Commit  modifies schema.prisma.
  echo "SCHEMA_CHANGED=true" >> $GITHUB_ENV
  export SCHEMA_CHANGED=$SCHEMA_CHANGED
  exit 0
else
  echo "SCHEMA_CHANGED=false" >> $GITHUB_ENV
  export SCHEMA_CHANGED=$SCHEMA_CHANGED
  exit 0
fi