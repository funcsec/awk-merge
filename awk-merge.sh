#!/usr/bin/env bash

# awk merge 
#   mass mailer using GNU/Linux tools

#set -euo pipefail

[[ -z $3 ]] && MSMTPCONF="./msmtprc-example"      || MSMTPCONF="$3"
[[ -z $2 ]] &&  TEMPLATE="./example-template.txt" || TEMPLATE="$2"
[[ -z $1 ]] &&  CONTACTS="./example-contacts.csv" || CONTACTS="$1"

CONTACTSTMP="$(mktemp)"
ACCOUNT="default"
tail -n +2 "$CONTACTS" > "$CONTACTSTMP"

while read -r i; do
  EMAIL="$(echo $i | awk -F, '{ print $2 }')"
  if [ -x $EMAIL ]; then
    echo "$i" | awk -f ./awk-merge.awk -v template="$TEMPLATE"
    firefox "$(echo $i | awk -F, '{ print $3 }')"
    echo "==========================================="
  else
    echo "$i" | awk -f ./awk-merge.awk -v template="$TEMPLATE" \
    | msmtp -a "$ACCOUNT" "$EMAIL"
  fi
  sleep 5
done < "$CONTACTSTMP" 
rm "$CONTACTSTMP"
