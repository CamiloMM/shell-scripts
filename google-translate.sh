#!/bin/bash
# syntax:  google-translate.sh SOURCE TARGET PHRASE
# example: google-translate.sh auto pt-BR "Spaghetti alla puttanesca means spaghetti of the whore"
SL="$1"
SD="$2"
shift 2
CONTENT="$@"
CONTENT="$(echo $CONTENT | sed -r "s/ /+/g")"
TEXT="$(curl -s -A "Mozilla" "http://translate.google.com/translate_a/t?client=t&hl=$SD&sl=$SL&multires=1&ssel=0&tsel=0&sc=1&text=$CONTENT" | awk -F'"' '{print $2}';)"
echo "$TEXT"
