TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/bat
TERMUX_PKG_DESCRIPTION="A cat(1) clone with wings"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=0.15.4
TERMUX_PKG_SRCURL=https://github.com/sharkdp/bat/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=03b7c8ad6221ca87cecd71f9e3e2167f04f750401e2d3dcc574183aabeb76a8b
# bat calls less with '--RAW-CONTROL-CHARS' which busybox less does not support:
TERMUX_PKG_DEPENDS="less, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS="$CFLAGS $CPPFLAGS"

	# See https://github.com/nagisa/rust_libloading/issues/54
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu=""
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $(find . -name bat.1) $TERMUX_PREFIX/share/man/man1/
}
