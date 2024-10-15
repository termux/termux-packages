#!/usr/bin/env bash
# setup CGCT - Cross Gnu Compilers for Termux
# compile glibc-based binaries for Termux

. $(dirname "$(realpath "$0")")/properties.sh
. $(dirname "$(realpath "$0")")/build/termux_download.sh

set -e -u

ARCH="x86_64"
REPO_URL="https://service.termux-pacman.dev/cgct/${ARCH}"

if [ "$ARCH" != "$(uname -m)" ]; then
	echo "Error: the requested CGCT is not supported on your architecture"
	exit 1
fi

declare -A CGCT=(
	["cbt"]="2.43.1-0" # Cross Binutils for Termux
	["cgt"]="14.2.0-0" # Cross GCCs for Termux
	["glibc-cgct"]="2.40-2" # Glibc for CGCT
 	["cgct-headers"]="6.10-0" # Headers for CGCT
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
curl "${REPO_URL}/cgct.json" -o "${TMPDIR_CGCT}/cgct.json"
for pkgname in ${!CGCT[@]}; do
	SHA256SUM=$(jq -r '."'$pkgname'"."SHA256SUM"' "${TMPDIR_CGCT}/cgct.json")
	if [ "$SHA256SUM" = "null" ]; then
		echo "Error: package '${pkgname}' not found"
		exit 1
	fi
	version="${CGCT[$pkgname]}"
	version_of_json=$(jq -r '."'$pkgname'"."VERSION"' "${TMPDIR_CGCT}/cgct.json")
	if [ "${version}" != "${version_of_json}" ]; then
		echo "Error: versions do not match: requested - '${version}'; actual - '${version_of_json}'"
		exit 1
	fi
	filename=$(jq -r '."'$pkgname'"."FILENAME"' "${TMPDIR_CGCT}/cgct.json")
	if [ ! -f "${TMPDIR_CGCT}/${filename}" ]; then
		termux_download "${REPO_URL}/${filename}" \
			"${TMPDIR_CGCT}/${filename}" \
			"${SHA256SUM}"
	fi
	tar xJf "${TMPDIR_CGCT}/${filename}" -C / data
done

# Installing gcc-libs for CGCT
if [ ! -f "${CGCT_DIR}/lib/libgcc_s.so" ]; then
	pkgname="gcc-libs"
	echo "Installing ${pkgname} for CGCT..."
	curl -L "https://archlinux.org/packages/core/${ARCH}/${pkgname}/download/" -o "${TMPDIR_CGCT}/${pkgname}.pkg.zstd"
	tar --use-compress-program=unzstd -xf "${TMPDIR_CGCT}/${pkgname}.pkg.zstd" -C "${TMPDIR_CGCT}" usr/lib
	cp -r "${TMPDIR_CGCT}/usr/lib/"* "${CGCT_DIR}/lib"
fi

# Setting up CGCT
if [ ! -f "${CGCT_DIR}"/bin/setup-cgct ]; then
	echo "Error: setup-cgct command not found in CGCT directory"
	exit 1
fi
"${CGCT_DIR}"/bin/setup-cgct "/usr/lib/x86_64-linux-gnu"
