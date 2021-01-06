TERMUX_PKG_HOMEPAGE=https://the.exa.website
TERMUX_PKG_DESCRIPTION="A modern replacement for ls"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/ogham/exa/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=96e743ffac0512a278de9ca3277183536ee8b691a46ff200ec27e28108fef783
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-default-features --features default"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm $TERMUX_PKG_SRCDIR/Makefile
	termux_setup_rust

	CFLAGS="$CFLAGS $CPPFLAGS"
	cargo update
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/contrib/man/exa.1 $TERMUX_PREFIX/share/man/man1/
}
