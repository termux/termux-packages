#!/bin/sh
set -e -u

srcdir=$(realpath "$(dirname "$0")")

rm -Rf debian-*.patch

checkout_dir=$(mktemp -d)
cd "$checkout_dir"
git clone --depth=1 https://salsa.debian.org/multimedia-team/ffmpeg.git

for patch in ffmpeg/debian/patches/*.patch; do
	new_patch=debian-$(basename "$patch")
	echo "$patch" -> "$new_patch"
	cp "$patch" "$srcdir/$new_patch"
done

rm -Rf "$checkout_dir"
