#!/bin/sh
# Make a single thumbnail for a video (first parameter).
# If you pass a second parameter, it will be the name of the file, else it will be "thumb.jpg".
# As a failsafe, the thumbnail file won't be over-written. Delete first if desired.

if [[ -z "$1" ]]; then
	echo pass a video name as a parameter.
	exit 1
fi

input="$1"

if [[ -n "$2" ]]; then
	output="$2"
else
	output="thumb.jpg"
fi

# Get the time as h:m:s (non-padded)
len=$(ffmpeg -i "$input" 2>&1 | grep Duration: | sed -r 's/\..*//;s/.*: //;s/0([0-9])/\1/g')
# Convert that into seconds
sec=$((($(cut -f1 -d: <<< $len) * 60 + $(cut -f2 -d: <<< $len)) * 60 + $(cut -f3 -d: <<< $len)))
# Get frame at 25% as the thumbnail
ffmpeg -ss $((sec / 4)) -y -i "$input" -r 1 -updatefirst 1 -frames 1 "$output" 2> /dev/null
