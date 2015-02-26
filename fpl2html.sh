#!/bin/bash

# fplreader does not support writing to stdout so we're using a temp file.
temp="/tmp/fpl2html-$RANDOM$RANDOM$RANDOM$RANDOM.csv"
fplreader "$1" "$temp" -csv > /dev/null
csv="$(cat "$temp" | tail +2)"
rm -f "$temp"

# Note that XML encoding is valid in HTML too.
# Also, note that due to this being intended to be used on a site that interprets @, I've encoded it too.
xmlentities() { sed -r 's/\\/\\\\/g;s/&/\&amp;/g;s/"/\&quot;/g;s/'\''/\&apos;/g;s/</\&lt;/g;s/>/\&gt;/g;s/@/\&#x40;/g' | iconv -f UTF-8 -t JAVA | sed -r 's/\\u([0-9a-f]{4})/\&#x\1;/g;s/\\&#x([0-9a-f]{4});/\\u\1/g'; }
encodeURIComponent() { perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'; }

parseline() {
    # Not even recursively enumerable grammar is capable of expressing how ugly a regex can be.
    pattern1='^"(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)",(.*),.*,".*",".*",.*,".*"$'
    pattern2='^".*",".*",".*",".*",".*",".*",".*",".*",.*,(.*),"(.*)","(.*)",(.*),".*"$'
    unescape='s/\\"/"/g;'"s/\\\\'/'/g"
    filename="$(sed -r "s/$pattern1/\1/;$unescape;s/^.*\\\\\\\\//" <<< "$1")"
    title="$(sed -r "s/$pattern1/\2/;$unescape" <<< "$1")"
    titleParsed="$title"
    if [[ -z "$title" ]]; then titleParsed="$(sed -r 's/\.[^.]+$//' <<< "$filename")"; fi
    artist="$(sed -r "s/$pattern1/\3/;$unescape" <<< "$1")"
    albumArtist="$(sed -r "s/$pattern1/\4/;$unescape" <<< "$1")"
    artistParsed="$artist"
    if [[ -z "$artist" ]]; then artistParsed="$albumArtist"; fi
    album="$(sed -r "s/$pattern1/\5/;$unescape" <<< "$1")"
    tracknum="$(sed -r "s/$pattern1/\6/" <<< "$1")"
    genre="$(sed -r "s/$pattern1/\7/" <<< "$1")"
    year="$(sed -r "s/$pattern1/\8/" <<< "$1")"
    duration="$(sed -r "s/$pattern1/\9/" <<< "$1")"
    durationParsed="$(($(cut -d. -f1 <<< "$duration") / 60)):$(printf %s "0$(($(cut -d. -f1 <<< "$duration") % 60))" | tail -c2)"
    bitrate="$(sed -r "s/$pattern2/\1/" <<< "$1")"
    codec="$(sed -r "s/$pattern2/\2/" <<< "$1")"
    codecProfile="$(sed -r "s/$pattern2/\3/" <<< "$1")"
    filesize="$(sed -r "s/$pattern2/\4/" <<< "$1")"
    # Lotta fields, huh? We'll use just some of 'em. If you're repurposing this script,
    # this is the part where you could delete the rest of this function and put your custom logic.
    artistPrefix="$([[ -n "$artistParsed" ]] && echo "$artistParsed - ")"
    searchQuery="$artistPrefix$titleParsed"
    google="$(searchIcon Google google.com "$searchQuery" 'https://google.com/search?q=')"
    youtube="$(searchIcon YouTube youtube.com "$searchQuery" 'https://www.youtube.com/results?search_query=')"
    soundcloud="$(searchIcon SoundCloud soundcloud.com "$searchQuery" 'https://soundcloud.com/search?q=')"
    grooveshark="$(searchIcon Grooveshark grooveshark.com "$searchQuery" 'http://grooveshark.com/#!/search?q=')"
    icons="$google $youtube $grooveshark"
    echo "    <li>$icons $(xmlentities <<< "$artistPrefix")<i>$(xmlentities <<< "$titleParsed")</i> ($durationParsed)</li>"
}

# We're adding search icons to each song, this function generates their HTML.
# Parameters: name domain query urlPrefix [urlSuffix]
searchIcon() {
    echo -n "<a title=\"Search on $1\" href=\"$4$(encodeURIComponent <<< "$3")$5\" target=\"_blank\">"
    echo -n "<sub><img src=\"https://www.google.com/s2/favicons?domain=$2\" height=\"16\"/></sub></a>"
}

echo '<ul>'
while read -r line; do parseline "$line"; done <<< "$csv"
echo '</ul>'
