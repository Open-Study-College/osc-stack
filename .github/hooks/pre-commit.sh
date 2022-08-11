#!/bin/sh

branch="$(git rev-parse --abbrev-ref HEAD)"

if [ "$branch". ]; then
  if [ "$(git diff --exit-code ./prisma/schema.prisma)" = "1" ]; then
    echo "Cannot change the schema in a non-db branch. Aborting commit..."
    echo "Unstage schema.prisma to commit."
    exit 1
  fi
fi