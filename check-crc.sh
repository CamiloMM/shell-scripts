#!/bin/bash
# Checks CRCs. If you point it to a file, it will check the file.
# If you point it to a directory, it will iterate it recursively for files.
# Only files which contain a valid CRC32 in the filename will be checked.
# Files won't be modified, just validation status will be printed to STDERR
# and an error code will be returned (0 = all valid, 1 = any invalid).
# Additionally, exit codes 2, 3 and 4 indicate user error.

if [[ -z "$1" ]]; then
    echo 'No arguments specified!' >&2
    echo 'Specify a file or directory.' >&2
    exit 2
fi

# Rewrite this method if you don't want to depend on Python.
crc32() {
    # Python's forced indentation is such a massive boner kill, akin to BASIC or COBOL.
    py='import sys, zlib, os; file = open(sys.argv[1], "rb"); block = 65536; crc = 0
while True:
    data = file.read(block)
    if not data: break
    crc = zlib.crc32(data, crc)
file.close()
if crc < 0: crc &= 2**32-1
print("%.8X" %(crc))'
    python -c "$py" "$1"
}

if [[ -d "$1" ]]; then
    echo "Processing directory with $(find "$1" -type f | wc -l | tr -d ' ') files..." >&2
    # http://stackoverflow.com/a/15541392 ("Set a variable from a subshell")
    export tempfile="/tmp/check-crc.sh-$RANDOM-$RANDOM-$RANDOM-$RANDOM.var"
    printf %s '0,0,0' > "$tempfile"
    iterate() {
        replace='s/^(.*[^a-zA-Z0-9])?([a-fA-F0-9]{8})([^a-zA-Z0-9].*)?$/\2/g'
        crc32="$(printf %s "$1" | sed -r "$replace" | awk '{print toupper($0)}')"
        if grep -qE '^[A-F0-9]{8}$' <<< "$crc32"; then
            processed="$(cat "$tempfile" | cut -f 1 -d ,)"
            ignored="$(cat "$tempfile" | cut -f 2 -d ,)"
            failed="$(cat "$tempfile" | cut -f 3 -d ,)"
            let processed++
            actual="$(crc32 "$1")"
            if [[ "$crc32" != "$actual" ]]; then
                echo "[$actual]: $(basename "$1")" >> "$tempfile.msg"
                let failed++
            fi
            printf %s "$processed,$ignored,$failed" > "$tempfile"
            printf %s . >&2
        else
            processed="$(cat "$tempfile" | cut -f 1 -d ,)"
            ignored="$(cat "$tempfile" | cut -f 2 -d ,)"
            failed="$(cat "$tempfile" | cut -f 3 -d ,)"
            let ignored++
            printf %s "$processed,$ignored,$failed" > "$tempfile"
            printf %s . >&2
        fi
    }
    # http://stackoverflow.com/a/4321522 ("find -exec a shell function?")
    export -f iterate
    export -f crc32
    find "$1" -type f -exec bash -c 'iterate "$0"' {} \;
    processed="$(cat "$tempfile" | cut -f 1 -d ,)"
    ignored="$(cat "$tempfile" | cut -f 2 -d ,)"
    failed="$(cat "$tempfile" | cut -f 3 -d ,)"
    rm -f "$tempfile"
    echo 'done.' >&2
    printf %s "$ignored files ignored, $processed files processed, " >&2
    if ((failed)); then
        echo "$failed files do not match their CRC32s:" >&2
        cat "$tempfile.msg"
        rm -f "$tempfile.msg"
        exit 1
    else
        echo 'all files OK.' >&2
    fi
elif [[ -f "$1" ]]; then
    replace='s/^(.*[^a-zA-Z0-9])?([a-fA-F0-9]{8})([^a-zA-Z0-9].*)?$/\2/g'
    crc32="$(printf %s "$1" | sed -r "$replace" | awk '{print toupper($0)}')"
    if grep -qE '^[A-F0-9]{8}$' <<< "$crc32"; then
        actual="$(crc32 "$1")"
        if [[ "$crc32" != "$actual" ]]; then
            echo 'File does not match expected checksum:' >&2
            echo "[$actual]: $(basename "$1")" >&2
            exit 1
        else
            echo 'File OK.' >&2
        fi
    else
        echo 'Could not find a valid CRC32 in the file supplied!' >&2
        exit 4
    fi
else
    echo 'Argument must be a file or directory!' >&2
    exit 3
fi
