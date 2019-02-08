#!/bin/bash

# Downloads images from Sankaku Channel, by tag list.
# It accepts a space-separated list of tags as first argument (see example)
# and outputs downloaded images to a directory named after the tags.
# Notice that forbidden characters will be replaced by the question character (�).

tagCount=$(tr -dc ' ' <<< " $1" | awk '{ print length; }')

if [[ -z "$1" ]] || grep -qE '^-h|--help$' <<< "$1" || ((tagCount > 4)); then
    echo 'Please provide a list of up to 4 tags as the first argument.'
    echo 'example:'
    echo "    sankaku-downloader.sh 'hjl brown_hair -rating:e'"
    exit 0
fi

encodeURIComponent() {
    perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge';
}

tags="$(encodeURIComponent <<< "$1")"
dirName="$(head -n1 <<< "$1" | sed -r 's#[\/:*?\"<>|]#�#g')"
chan="https://chan.sankakucomplex.com"
useragent="user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/71.0.3578.98 Chrome/71.0.3578.98 Safari/537.36"
# Modify this to get from 26+ page (without login you can see only firsts 25)
# Set your username and your password hashed (see in networks tab and get them from cookies)
cookie='Cookie: locale=en; auto_page=1; login=Username; pass_hash=ed4f078hashedpassword;'

getResultPage() {
    curl -s "$chan/post/index.content?tags=$tags&page=$1" -H "$useragent" -H "$cookie"
}

pageNumber=0
nextPage() {
    let pageNumber++
    pageContent="$(getResultPage $pageNumber)"
    if (($?)); then return 1; fi
    grep -q '/post/show/' <<< "$pageContent"
}

getUrls() {
    grep '/post/show/' | sed -r 's/^.*?href="//g;s/".*$//g'
}

downloadPost() {
    html="$(curl -s "$1" -H "$useragent")"
    if (($?)); then echo -n ' X'; return 1; fi
    re='cs\.sankakucomplex\.com/data/[a-f0-9]'
    sed="s#^.*($re)#https://\\1#;s/\".*\$//"
    url="$(grep -E "$re" <<< "$html" | head -n1 | sed -r "$sed")"
    url="$(sed 's/amp;//g' <<< $url)"
    fileName="$(sed 's#^.*/##;s/\?.*$//' <<< "$url")"
    curl -s "$url" -H "$useragent" > "$dirName/$fileName"
    if (($?)); then echo -n ' X'; return 1; fi
    echo -n ' ✓'
}

anyPageYet=false
while nextPage; do
    anyPageYet=true
    mkdir -p "$dirName"
    if [[ ! -d "$dirName" ]]; then
        echo 'Cannot create a directory to store downloaded files here!'
        exit 1
    fi
    echo -n "Downloading page $pageNumber..."
    for post in $(getUrls <<< "$pageContent"); do
        downloadPost "$chan$post"
    done
    echo
done

if ! $anyPageYet; then
    echo "No results were found for \"$1\"."
fi
