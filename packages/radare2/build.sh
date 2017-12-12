TERMUX_PKG_HOMEPAGE=https://rada.re
TERMUX_PKG_DESCRIPTION="Advanced Hexadecimal Editor"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_SHA256=cf34e6260fafb543edb919ed0b80b57b431817e91b624843fc1b82aa4bbf5f7a
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
