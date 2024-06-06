#!/usr/bin/env bash

<<<<<<< HEAD
wait-for-url() {
  echo -n "Waiting $1 "
  timeout --foreground -s TERM 180s bash -c \
  'while [[ "$(curl -k -s -o /dev/null -m 3 -L -w ''%{http_code}'' ${0})" != "200" ]];\
   do
   echo -n "."
   sleep 1
   done' ${1}
   TIMEOUT_RETURN="$?"
   if [[ "$TIMEOUT_RETURN" == 0 ]]; then
     echo -e "\n[+] ${1} - 200 OK"
   else
     echo -e "\n[-] ${1} - timeout or other error! [$TIMEOUT_RETURN]"
   fi
}

clear
echo -e "URLs: $@\n"

for var in "$@"; do
  wait-for-url "$var"
done
=======
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
>>>>>>> main
