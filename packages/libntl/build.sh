TERMUX_PKG_HOMEPAGE="https://libntl.org"
TERMUX_PKG_DESCRIPTION="A Library for doing Number Theory"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="doc/copying.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="11.6.0"
TERMUX_PKG_SRCURL="https://libntl.org/ntl-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=bc0ef9aceb075a6a0673ac8d8f47d5f8458c72fe806e4468fbd5d3daff056182
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libgf2x, libgmp"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, perl"

termux_step_pre_configure() {
	# configure and make compile and run helper programs to probe the target compiler.
	declare -ga termux_proot_run=()

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_setup_proot
		termux_proot_run=(termux-proot-run env LD_PRELOAD= LD_LIBRARY_PATH=)
	fi
}

termux_step_configure() {
	cd src

	case "$TERMUX_ARCH" in
		x86_64 | i686 )
			tune="x86";;
		* )
			tune="generic";;
	esac

	# proot puts $TERMUX_PREFIX/bin first in PATH, which could shadow these by name even in CI.
	local cxx ar ranlib
	cxx="$(command -v "$CXX")"
	ar="$(command -v "$AR")"
	ranlib="$(command -v "$RANLIB")"

	"${termux_proot_run[@]}" ./configure \
		PREFIX=$TERMUX_PREFIX \
		CXX="$cxx" \
		CXXFLAGS="$CXXFLAGS" \
		LDFLAGS="$LDFLAGS" \
		AR="$ar" \
		RANLIB="$ranlib" \
		GMP_PREFIX="$TERMUX_PREFIX" \
		NATIVE=off \
		TUNE="$tune" \
		NTL_GMP_LIP=on \
		NTL_GF2X_LIB=off
}

termux_step_make() {
	cd src
	"${termux_proot_run[@]}" make
}

termux_step_make_install() {
	cd src
	make install
}
