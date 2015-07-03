#!/bin/bash
# This simple script encodes whatever is given to it from stdin as
# an URI component (e.g., for URL parameters), and outputs it to stdout.
# Optionally, you can pass what's to be encoded as regular arguments
# (no options exist, not even --help). Additionally, since shells seem to
# like adding trailing newlines to everything, these are removed so this:
#     encode-uri-component.sh 'foo bar' # or <<< 'foo bar'!
# will result in "foo%20bar" and not "foo%20bar%0A".
if [[ -n "$*" ]]; then
	perl -pe 'chomp if eof;s/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge' <<< "$*"
else
	perl -pe 'chomp if eof;s/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'
fi
