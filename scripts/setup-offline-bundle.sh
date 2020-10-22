#!/usr/bin/env bash
##
## Download and install all build tools whether applicable now, so
## they will be available later for offline use.
##

set -e -u

if [ "$(uname -o)" = "Android" ] || [ "$(uname -m)" != "x86_64" ]; then
	echo "This script supports only x86_64 GNU/Linux systems."
	exit 1
fi

export TERMUX_SCRIPTDIR="$(dirname "$(readlink -f "$0")")/../"
mkdir -p "$TERMUX_SCRIPTDIR"/build-tools

export TERMUX_PACKAGES_OFFLINE=true
export TERMUX_ARCH=aarch64
export TERMUX_ON_DEVICE_BUILD=false
export TERMUX_PKG_TMPDIR=$TERMUX_SCRIPTDIR/build-tools/_tmp
export TERMUX_COMMON_CACHEDIR=$TERMUX_PKG_TMPDIR
export CC=gcc CXX=g++ LD=ld AR=ar STRIP=strip PKG_CONFIG=pkg-config
export CPPFLAGS="" CFLAGS="" CXXFLAGS="" LDFLAGS=""
mkdir -p "$TERMUX_PKG_TMPDIR"

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
# Offline rust is not supported yet.
#(. "$TERMUX_SCRIPTDIR"/scripts/build/setup/termux_setup_rust.sh
#	termux_setup_rust
#)
rm -rf "${TERMUX_PKG_TMPDIR}"
