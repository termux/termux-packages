#!/usr/bin/env bash
# setup CGCT - Cross Gnu Compiler for Termux
# compile glibc-based binaries for Termux

. $(dirname "$(realpath "$0")")/properties.sh
. $(dirname "$(realpath "$0")")/build/termux_download.sh

set -e -u

ARCH="x86_64"
REPO_URL="https://service.termux-pacman.dev/gpkg-dev/${ARCH}"
VERSION_OF_CBT="2.41-1"
VERSION_OF_CGT="13.2.0-4"

if [ "$ARCH" != "$(uname -m)" ]; then
	echo "Error: the requested CGCT is not supported on your architecture"
	exit 1
fi

declare -A CGCT=(
	["cbt"]="cbt-${VERSION_OF_CBT}-${ARCH}.pkg.tar.xz" # Cross Binutils for Termux
	["cgt"]="cgt-${VERSION_OF_CGT}-${ARCH}.pkg.tar.xz" # Cross GCC for Termux
)

: "${TERMUX_PKG_TMPDIR:="/tmp"}"
TMPDIR_CGCT="${TERMUX_PKG_TMPDIR}/cgct"

# Creating a directory for CGCT in tmp
if [ ! -d "$TMPDIR_CGCT" ]; then
	mkdir -p "$TMPDIR_CGCT"
fi

# Removing the old CGCT
if [ -d "$CGCT_DIR" ]; then
	echo "Removing the old CGCT..."
	rm -fr "$CGCT_DIR"
fi

# Installing CGCT
echo "Installing CGCT..."
curl "${REPO_URL}/gpkg-dev.json" -o "${TMPDIR_CGCT}/cgct.json"
for pkgname in ${!CGCT[@]}; do
	SHA256SUM=$(jq -r '."'$pkgname'"."SHA256SUM"' "${TMPDIR_CGCT}/cgct.json")
	if [ "$SHA256SUM" = "null" ]; then
		echo "Error: package '${pkgname}' not found"
		exit 1
	fi
	filename="${CGCT[$pkgname]}"
	filename_of_json=$(jq -r '."'$pkgname'"."FILENAME"' "${TMPDIR_CGCT}/cgct.json")
	if [ "$filename" != "$filename_of_json" ]; then
		echo "Error: files do not match: requested - '$filename'; actual - '$filename_of_json'"
		exit 1
	fi
	if [ ! -f "${TMPDIR_CGCT}/${filename}" ]; then
		termux_download "${REPO_URL}/${filename}" \
			"${TMPDIR_CGCT}/${filename}" \
			"$SHA256SUM"
	fi
	tar xJf "${TMPDIR_CGCT}/${filename}" -C / data
done

# Installing glibc for CGCT
if [ ! -d "${CGCT_DIR}/lib" ]; then
	echo "Installing glibc for CGCT..."
	for i in glibc gcc-libs; do
		curl -L "https://archlinux.org/packages/core/${ARCH}/${i}/download/" -o "${TMPDIR_CGCT}/${i}.pkg.zstd"
		tar --use-compress-program=unzstd -xf "${TMPDIR_CGCT}/${i}.pkg.zstd" -C "${TMPDIR_CGCT}" usr
	done
	cp -r "${TMPDIR_CGCT}/usr/lib" "${CGCT_DIR}/lib"
fi

# Setting up CGCT for this glibc
echo "Setting up CGCT for this glibc..."
LD_LIB=$(ls ${CGCT_DIR}/lib/ld-* 2> /dev/null)
if [ ! -n "$LD_LIB" ]; then
	echo "Error: interpreter not found in lib directory"
	exit 1
fi
for i in aarch64 arm x86_64 i686; do
	for j in bin lib/gcc; do
		for f in $(find "${CGCT_DIR}/${i}/${j}" -type f -exec grep -IL . "{}" \; | grep -v -e '\.a' -e '\.o' -e '\.so'); do
			patchelf --set-rpath "${CGCT_DIR}/lib:/usr/lib:/usr/lib64" \
				--set-interpreter "$LD_LIB" "$f"
			echo "Configured '${f}'"
		done
	done
done
