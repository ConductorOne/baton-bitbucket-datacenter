#!/usr/bin/env bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <url>"
  exit 1
fi

set -euxo pipefail

for i in {1..10}
do
  if curl -f $1 | jq --exit-status ".state == \"RUNNING\""; then
    echo "Running"
    exit 0
  fi
  echo "Not running"
  sleep 10
done

echo "$0: Giving up after 10 attempts"
exit 1
