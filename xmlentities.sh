#!/bin/bash
# Inserts XML entities into raw text from STDIN and writes it to STDOUT.
sed -r 's/\\/\\\\/g;s/&/\&amp;/g;s/"/\&quot;/g;s/'\''/\&apos;/g;s/</\&lt;/g;s/>/\&gt;/g' \
| iconv -f UTF-8 -t JAVA | sed -r 's/\\u([0-9a-f]{4})/\&#x\1;/g;s/\\&#x([0-9a-f]{4});/\\u\1/g'
