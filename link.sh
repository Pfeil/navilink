#!/usr/bin/env bash

### CUSTOMIZE THIS #####################
BASE_URL="http://localhost:8000/v1"
IDENTIFIER="MyComputer"
PASSPHRASE="someRandomString"
ITEM_TO_STORE=$HOSTNAME
########################################

URL="$BASE_URL/$IDENTIFIER"
COMMAND=$1

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
    curl -L -X PUT "$URL" -d "$body"
elif equals $COMMAND "pull"
then
body='"'$PASSPHRASE'"'
    curl -L -X POST $URL -d "$body"
else
    echo "Valid commands are:" push pull
fi
