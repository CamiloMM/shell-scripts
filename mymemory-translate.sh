#!/bin/bash
# syntax:  mymemory-translate.sh SOURCE TARGET PHRASE
# example: mymemory-translate.sh '' pt-BR 'Spaghetti alla puttanesca means spaghetti of the whore'
source="$1"
dest="$2"
shift 2
encodeURIComponent() { perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'; }
content="$(printf %s "$@" | encodeURIComponent)"
# We must *detect* the language first, like in the Yandex script.
if [[ -z "$source" ]]; then # And only if the user didn't supply the source, of course.
    source="$(wget -qO- "http://mymemory.translated.net/en/Autodetect/English/$content" | grep '</title>' | sed -r 's# -[^<-]+</title>.*$##;s/^.* - ([^-]+)$/\1/')"
fi
pair="$source|$dest"
json="$(curl -s "http://mymemory.translated.net/api/get?q=$content&langpair=$pair")"
node -e "process.stdout.write(JSON.parse(process.argv[1]).responseData.translatedText)" "$json"
