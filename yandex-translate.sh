#!/bin/bash
# syntax:  yandex-translate.sh SOURCE TARGET PHRASE
# example: yandex-translate.sh '' pt-BR 'Spaghetti alla puttanesca means spaghetti of the whore'
source="$1"
dest="$2"
shift 2
encodeURIComponent() { perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'; }
content="$(printf %s "$@" | encodeURIComponent)"
# Now, this is annoying, but we must *detect* the language first. Yeah, even their web app does this, two requests.
if [[ -z "$source" ]]; then # And only if the user didn't supply the source, of course.
	source="$(curl -s "https://translate.yandex.net/api/v1/tr.json/detect?srv=tr-text&text=$content" | sed -r 's/.*lang":"//;s/".*//')"
fi
pair="$source-$dest"
text="$(curl -s "http://translate.yandex.net/tr.json/translate?lang=$pair&text=$content&srv=tr-text" | sed -r 's/^"//;s/"$//')"
printf %s "$text"
