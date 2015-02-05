#!/bin/bash
# syntax:  google-translate.sh SOURCE TARGET PHRASE
# example: google-translate.sh auto pt-BR 'Spaghetti alla puttanesca means spaghetti of the whore'
SL="$1"
SD="$2"
shift 2
encodeURIComponent() { perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'; }
CONTENT="$(printf %s "$@" | encodeURIComponent)"
TEXT="$(curl -s -A "Mozilla" "https://translate.google.com/translate_a/single?client=t&sl=auto&hl=en&dt=t&ie=UTF-8&oe=UTF-8&q=$CONTENT" | awk -F'"' '{print $2}')"
echo "$TEXT"
