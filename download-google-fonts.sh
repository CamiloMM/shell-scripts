#!/bin/bash
# Downloads google fonts so they can be used locally.
# To use, go to a directory and call this script while providing it the URL that Google
# gave you as source (like "http://fonts.googleapis.com/css?family=Asap:400,700italic").
# To download fonts for a specific user agent, pass it as the second argument. Example:
# 'Mozilla/5.0 AppleWebKit/537.36 Chrome/40.0.2214.111' (will download woff2).
# Aditionally, you may pass "ttf" (default), "woff"/"woff1" or "woff2" as shorthands.

# URLs given MUST match this expression.
if ! grep -qE '^(https?://)?fonts\.googleapis\.com/css\?.*family=.+$' <<< "$1"; then
    echo "A valid URL to Google's font services must be given."
    echo "Example: http://fonts.googleapis.com/css?family=Asap:400,700italic"
    exit 107
fi

# Strip the protocol if any, and add it back as http://
url="http://$(sed -r 's-^https?://--g' <<< "$1")"

# User agent, or format name (which is a bit of a hack).
chrome40='Mozilla/5.0 AppleWebKit/537.36 Chrome/40.0.2214.111'
firefox33='Mozilla/5.0 Gecko/20100101 Firefox/33.0'
case "$2" in
    woff|woff1)
        css="$(wget -qO- "$url" -U "$firefox33")" ;;
    woff2)
        css="$(wget -qO- "$url" -U "$chrome40")" ;;
    ''|ttf)
        css="$(wget -qO- "$url")" ;;
    *)
        css="$(wget -qO- "$url" -U "$2")" ;;
esac

echo ""

# Normalizes a string so it can form a decent filename. Example:
# norm " Hello, it is a Good Day. " >>> "hello-it-is-a-good-day"
norm() {
    trim "$1" | tr '[:upper:] ' '[:lower:]-' | tr -cd '[:lower:]-'
}

# Taken from http://stackoverflow.com/a/3352015
trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

# Get extension from a filename/url.
ext() {
    # Got ideas from from http://stackoverflow.com/a/1403489
    filename="${1##*/}"
    base="${filename%.[^.]*}"
    ext="${filename:${#base}+1}"
    if [[ -z "$base" && -n "$ext" ]]; then
        base=".$ext"
        ext=""
    fi
    printf %s "$ext"
}

# Parses a line of the original CSS.
parseLine() {
    # Regular expressions for two specific lines we're interested in.
    charsetPattern='^/\* ([^*]+) \*/$'
    resourcePattern='^(.+) local\(.(.*?).\), url\(([^)]+)\) (.+)$'

    # Indentation.
    if grep -qE '^[a-z]' <<< "$1"; then printf %s '  '; fi
    
    if grep -qE "$charsetPattern" <<< "$1"; then
        charset="$(sed -r "s-$charsetPattern-\\1-" <<< "$1")"
        separator='-' # there won't be a filename separator unless there's a charset.
        echo "$1"
    elif grep -qE "$resourcePattern" <<< "$1"; then
        # I'm doing it this way to reduce number of sed calls.
        fields="$(sed -r "s/$resourcePattern/"'\1\x1F\2\x1F\3\x1F\4/' <<< "$1")"
        wrapBefore="$(cut -d $'\x1F' -f 1 <<< "$fields")"
        nameRaw="$(cut -d $'\x1F' -f 2 <<< "$fields")"
        url="$(cut -d $'\x1F' -f 3 <<< "$fields")"
        wrapAfter="$(cut -d $'\x1F' -f 4 <<< "$fields")"
        filename="$(norm "$nameRaw")$separator$(norm "$charset").$(ext "$url")"
        wget -q "$url" -O "$filename"
        echo "$wrapBefore local('$nameRaw'), url('$filename') $wrapAfter"
    else
        # Echo it, with an extra space if it's the end of a block.
        sed -r 's/^}$/}\n/' <<< "$1"
    fi
}

# Go through each line of the CSS.
echo "$css" | while read line; do parseLine "$line"; done
