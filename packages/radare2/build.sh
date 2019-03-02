TERMUX_PKG_HOMEPAGE=https://rada.re
TERMUX_PKG_DESCRIPTION="Advanced Hexadecimal Editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.3.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=3c092bdf8676d7d49537926258c50557bca98d7d669babfed6113ff82c403bcb
TERMUX_PKG_SRCURL=https://github.com/radare/radare2/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libuv"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-compiler=termux-host"

termux_step_pre_configure() {
	# Unset CPPFLAGS to avoid -I$TERMUX_PREFIX/include. This is because
	# radare2 build will put it's own -I flags after ours, which causes
	# problems due to name clashes (binutils header files).
	unset CPPFLAGS

	# If this variable is not set, then build will fail on linking with 'pthread'
	export ANDROID=1

	export OBJCOPY=$TERMUX_HOST_PLATFORM-objcopy

	# Remove old libs which may mess with new build:
	rm -f $TERMUX_PREFIX/lib/libr_*
}
