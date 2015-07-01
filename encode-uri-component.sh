#!/bin/bash
# This simple script encodes whatever is given to it from stdin as
# an URI component (e.g., for URL parameters), and outputs it to stdout.
perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'
