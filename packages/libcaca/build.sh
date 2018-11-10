TERMUX_PKG_HOMEPAGE=http://caca.zoy.org/wiki/libcaca
TERMUX_PKG_DESCRIPTION="Graphics library that outputs text instead of pixels"
TERMUX_PKG_VERSION=0.99.beta19
TERMUX_PKG_REVISION=2
# Switched to mirror on 2014-12-22 since master was down:
TERMUX_PKG_SRCURL=http://fossies.org/linux/privat/libcaca-${TERMUX_PKG_VERSION}.tar.gz
#                     http://caca.zoy.org/files/libcaca/libcaca-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=128b467c4ed03264c187405172a4e83049342cc8cc2f655f53a2d0ee9d3772f4
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-python --disable-java --disable-ruby --disable-doc"

termux_step_post_configure () {
	if [ $TERMUX_ARCH = x86_64 ]; then
		# Remove troublesome asm usage:
		perl -p -i -e 's/#define HAVE_FLDLN2 1//' $TERMUX_PKG_BUILDDIR/config.h
	fi
}
