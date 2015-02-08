#!/bin/bash
# syntax:  google-translate.sh SOURCE TARGET PHRASE
# example: google-translate.sh auto pt-BR 'Spaghetti alla puttanesca means spaghetti of the whore'
source="$1"
dest="$2"
shift 2
encodeURIComponent() { perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'; }
original="$(printf %s "$@" | encodeURIComponent)"
json="$(curl -s -A "Mozilla" "https://translate.google.com/translate_a/single?client=t&sl=$source&hl=$dest&dt=t&ie=UTF-8&oe=UTF-8&q=$original")"
# Now this may seem too much work because we could use sed/awk/etc. instead, but besides being "the right thing"
# to parse JSON correctly, Google Translate also separates phrases, so this is a no-brainer. Besides I love js.
node -e "process.stdout.write(($json)[0].map(function(i){return i[0]}).join(''))"
