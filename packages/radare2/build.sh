TERMUX_PKG_HOMEPAGE=https://rada.re
TERMUX_PKG_DESCRIPTION="Advanced Hexadecimal Editor"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SHA256=99ba2a7c4aae99ae0c70ce0423fa6ed2344fb94a45bc83bf6c8716e2b3e7f1bf
TERMUX_PKG_SRCURL=https://github.com/radare/radare2/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-compiler=termux-host"

termux_step_pre_configure() {
	# Unset CPPFLAGS to avoid -I$TERMUX_PREFIX/include. This is because
	# radare2 build will put it's own -I flags after ours, which causes
	# problems due to name clashes (binutils header files).
	unset CPPFLAGS

	# If this variable is not set, then build will fail on linking with 'pthread'
	export ANDROID=1

	# Remove old libs which may mess with new build:
	rm -f $TERMUX_PREFIX/lib/libr_*
}
