#!/usr/bin/env bash

### CUSTOMIZE THIS #####################
BASE_URL="http://localhost:8000/v1"
IDENTIFIER="MyComputer"
PASSPHRASE="someRandomString"
ITEM_TO_STORE=$HOSTNAME
########################################

URL="$BASE_URL/$IDENTIFIER"
COMMAND=$1
HEADER="Content-Type:application/json"

function exitErr {
    echo "ERROR -> EXITING." $@
    exit 1
}

function equals {
    test $1 = $2
    return $?
}

function assertCommandIs {
    test $1 = $2 || exitErr "Wrong command: $2"
}

if equals $COMMAND "push"
then
    body='{"passphrase": "'$PASSPHRASE'", "item": "'$ITEM_TO_STORE'"}'
    curl -L --post301 -X PUT -d "$body" -H $HEADER "$URL"
elif equals $COMMAND "pull"
then
body='"'$PASSPHRASE'"'
    curl -L --post301 -X POST -d "$body" -H $HEADER "$URL"
else
    echo "Valid commands are:" push pull
fi
