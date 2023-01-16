#!/usr/bin/env bash
##
## Download all package sources and install all build tools whether possible,
## so they will be available offline.
##

set -e -u

if [ "$(uname -o)" = "Android" ] || [ "$(uname -m)" != "x86_64" ]; then
	echo "This script supports only x86_64 GNU/Linux systems."
	exit 1
fi

export TERMUX_SCRIPTDIR="$(dirname "$(readlink -f "$0")")/../"
mkdir -p "$TERMUX_SCRIPTDIR"/build-tools

. "$TERMUX_SCRIPTDIR"/scripts/properties.sh
: "${TERMUX_MAKE_PROCESSES:="$(nproc)"}"
export TERMUX_MAKE_PROCESSES
export TERMUX_PACKAGES_OFFLINE=true
export TERMUX_ARCH=aarch64
export TERMUX_ON_DEVICE_BUILD=false
export TERMUX_PKG_TMPDIR="$TERMUX_SCRIPTDIR/build-tools/_tmp"
export TERMUX_COMMON_CACHEDIR="$TERMUX_PKG_TMPDIR"
export TERMUX_HOST_PLATFORM=aarch64-linux-android
export TERMUX_ARCH_BITS=64
export TERMUX_BUILD_TUPLE=x86_64-pc-linux-gnu
export TERMUX_PKG_API_LEVEL=24
export TERMUX_TOPDIR="$HOME/.termux-build"
export TERMUX_PYTHON_CROSSENV_PREFIX="$TERMUX_TOPDIR/python-crossenv-prefix"
export TERMUX_PYTHON_VERSION=$(. "$TERMUX_SCRIPTDIR/packages/python/build.sh"; echo "$_MAJOR_VERSION")
export CC=gcc CXX=g++ LD=ld AR=ar STRIP=strip PKG_CONFIG=pkg-config
export CPPFLAGS="" CFLAGS="" CXXFLAGS="" LDFLAGS=""
mkdir -p "$TERMUX_PKG_TMPDIR"

# Build tools.
. "$TERMUX_SCRIPTDIR"/scripts/build/termux_download.sh
(. "$TERMUX_SCRIPTDIR"/scripts/build/setup/termux_setup_cmake.sh
	termux_setup_cmake
)
# GHC fails. Skipping for now.
#(. "$TERMUX_SCRIPTDIR"/scripts/build/setup/termux_setup_ghc.sh
#	termux_setup_ghc
#)
(. "$TERMUX_SCRIPTDIR"/scripts/build/setup/termux_setup_golang.sh
	termux_setup_golang
)
(
	. "$TERMUX_SCRIPTDIR"/scripts/build/setup/termux_setup_ninja.sh
	. "$TERMUX_SCRIPTDIR"/scripts/build/setup/termux_setup_meson.sh
	termux_setup_meson
)
(. "$TERMUX_SCRIPTDIR"/scripts/build/setup/termux_setup_protobuf.sh
	termux_setup_protobuf
)
#(. "$TERMUX_SCRIPTDIR"/scripts/build/setup/termux_setup_python_pip.sh
#	termux_setup_python_pip
#)
# Offline rust is not supported yet.
#(. "$TERMUX_SCRIPTDIR"/scripts/build/setup/termux_setup_rust.sh
#	termux_setup_rust
#)
(. "$TERMUX_SCRIPTDIR"/scripts/build/setup/termux_setup_swift.sh
	termux_setup_swift
)
(. "$TERMUX_SCRIPTDIR"/scripts/build/setup/termux_setup_zig.sh
	termux_setup_zig
)
(test -d "$TERMUX_SCRIPTDIR"/build-tools/android-sdk && test -d "$TERMUX_SCRIPTDIR"/build-tools/android-ndk && exit 0
	"$TERMUX_SCRIPTDIR"/scripts/setup-android-sdk.sh
)
rm -rf "${TERMUX_PKG_TMPDIR}"

# Package sources.
for repo_path in $(jq --raw-output 'keys | .[]' $TERMUX_SCRIPTDIR/repo.json); do
	for p in "$TERMUX_SCRIPTDIR"/$repo_path/*; do
		(
			. "$TERMUX_SCRIPTDIR"/scripts/build/get_source/termux_step_get_source.sh
			. "$TERMUX_SCRIPTDIR"/scripts/build/get_source/termux_git_clone_src.sh
			. "$TERMUX_SCRIPTDIR"/scripts/build/get_source/termux_download_src_archive.sh
			. "$TERMUX_SCRIPTDIR"/scripts/build/get_source/termux_unpack_src_archive.sh

			# Disable archive extraction in termux_step_get_source.sh.
			termux_extract_src_archive() {
				:
			}

			TERMUX_PKG_NAME=$(basename "$p")
			TERMUX_PKG_BUILDER_DIR="${p}"
			TERMUX_PKG_CACHEDIR="${p}/cache"
			TERMUX_PKG_METAPACKAGE=false

			# Set some variables to dummy values to avoid errors.
			TERMUX_PKG_TMPDIR="${TERMUX_PKG_CACHEDIR}/.tmp"
			TERMUX_PKG_SRCDIR="${TERMUX_PKG_CACHEDIR}/.src"
			TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
			TERMUX_PKG_HOSTBUILD_DIR="$TERMUX_PKG_TMPDIR"
			TERMUX_PKG_GIT_BRANCH=""
			TERMUX_DEBUG_BUILD=false


			mkdir -p "$TERMUX_PKG_CACHEDIR" "$TERMUX_PKG_TMPDIR" "$TERMUX_PKG_SRCDIR"
			cd "$TERMUX_PKG_CACHEDIR"

			. "${p}"/build.sh || true
			if ! ${TERMUX_PKG_METAPACKAGE}; then
				echo "Downloading sources for '$TERMUX_PKG_NAME'..."
				termux_step_get_source

				# Delete dummy src and tmp directories.
				rm -rf "$TERMUX_PKG_TMPDIR" "$TERMUX_PKG_SRCDIR"
			fi
		)
	done
done

# Mark to tell build-package.sh to enable offline mode.
touch "$TERMUX_SCRIPTDIR"/build-tools/.installed
