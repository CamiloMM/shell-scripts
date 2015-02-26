#!/bin/bash
# syntax:  honyaku-translate.sh SOURCE TARGET PHRASE
# example: honyaku-translate.sh '' en "ここに翻訳したい文章を入力してください。入力言語は自動判定されます。"
source="$1"
dest="$2"
shift 2
encodeURIComponent() { perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'; }
original="$(printf %s "$@" | encodeURIComponent)"
base='http://honyaku.yahoo.co.jp'
# First we need to get this "crumb" value for the session.
crumb="$(curl -s "$base" | grep 'id="TTcrumb"' | sed -r 's/^.*value="//;s/".*$//')"
# Then we (may) need to detect language. Surprising how many of these translators do this.
c='process.stdout.write(JSON.parse(process.argv[1])' # Boilerplate
if [[ -z "$source" ]]; then
    url="$base/LangClassifyService/V1/predict_prob?query=$original&output=json"
    js="$c.ResultSet.Predict._content)"
    source="$(node -e "$js" "$(curl -s "$url")")"
fi
# Here's where we make a POST to get the translation, and parse the result JSON.
data="p=$original&ieid=$source&oeid=$dest&_crumb=$crumb&output=json"
js="$c.ResultSet.ResultText.Results.map(function(i){return i.TranslatedText}).join('\\n'))"
node -e "$js" "$(curl -s "$base/TranslationText" --data "$data")"
