TERMUX_PKG_HOMEPAGE=https://starship.rs
TERMUX_PKG_DESCRIPTION="A minimal, blazing fast, and extremely customizable prompt for any shell"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_VERSION=0.27.0
TERMUX_PKG_SRCURL=https://github.com/starship/starship/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=af1c4dd9b211a6271709c2cd2bbc81745d63907981474ff59084864dfd2bcf3a
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-default-features"

termux_step_pre_configure() {
	mkdir -p $TERMUX_PKG_TMPDIR/include
	cp $TERMUX_PREFIX/include/zlib.h $TERMUX_PKG_TMPDIR/include 
	cp $TERMUX_PREFIX/include/zconf.h $TERMUX_PKG_TMPDIR/include
#	cp -r $TERMUX_PREFIX/include/openssl $TERMUX_PKG_TMPDIR/include
	CFLAGS+=" -I$TERMUX_PKG_TMPDIR/include"
}
