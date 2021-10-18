#!/bin/sh
set -eu

# this is needed mostly because $DESTDIR is provided as a variable,
# and we need to create the target directory...

mkdir -vp "$(dirname "${DESTDIR:-}$2")"

rm -f "${DESTDIR:-}$2"
ln -vs "$1" "${DESTDIR:-}$2"
