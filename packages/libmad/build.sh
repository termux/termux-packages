TERMUX_PKG_HOMEPAGE=http://www.underbit.com/products/mad/
TERMUX_PKG_DESCRIPTION="MAD is a high-quality MPEG audio decoder"
TERMUX_PKG_VERSION=0.15.1b
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=ftp://ftp.mars.org/pub/mpeg/libmad-${TERMUX_PKG_VERSION}.tar.gz

termux_post_configure() {
	cd $TERMUX_PKG_SRCDIR
	sed -i -e 's/-force-mem//g' Makefile
}
