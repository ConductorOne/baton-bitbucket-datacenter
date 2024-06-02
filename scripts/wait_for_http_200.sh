#!/usr/bin/env bash

##############################################################################################
# Wait for URLs until return HTTP 200
# - Just pass as many urls as required to the script - the script will wait for each, one by one
# Example: ./wait_for_urls.sh "${MY_VARIABLE}" "http://192.168.56.101:8080"
##############################################################################################

wait-for-url() {
  echo -n "Waiting $1 "
  timeout --foreground -s TERM 10s bash -c \
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