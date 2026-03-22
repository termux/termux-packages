#!/data/data/com.termux/files/usr/bin/bash

# Usage: quickgrep PATTERN [FILE or DIR]
if [ -z "$1" ]; then
    echo "Usage: quickgrep <pattern> [file_or_directory]"
    exit 1
fi

PATTERN="$1"
TARGET="${2:-.}"  # default to current directory

if [ ! -e "$TARGET" ]; then
    echo "Error: $TARGET does not exist"
    exit 1
fi

if [ -d "$TARGET" ]; then
    grep -rn --color=always "$PATTERN" "$TARGET" | tee >(wc -l >&2)
else
    grep -n --color=always "$PATTERN" "$TARGET" | tee >(wc -l >&2)
fi
