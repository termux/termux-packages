TERMUX_PKG_HOMEPAGE=https://github.com/nicm/fdm
TERMUX_PKG_DESCRIPTION="A program designed to fetch mail from POP3 or IMAP servers, or receive local mail from stdin, and deliver it in various ways"
TERMUX_PKG_LICENSE="ISC, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_SRCURL=https://github.com/nicm/fdm/releases/download/${TERMUX_PKG_VERSION}/fdm-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=06b28cb6b792570bc61d7e29b13d2af46b92fea77e058b2b17e11e8f7ed0cea4
TERMUX_PKG_DEPENDS="libandroid-glob, libtdb, openssl, pcre, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
--localstatedir=$TERMUX_PREFIX/var
--disable-static
--enable-pcre
"

termux_step_pre_configure() {
	# Source distribution does not have separate license files
	for f in LICENSE LICENSE.BSD; do
		cp $TERMUX_PKG_BUILDER_DIR/$f $TERMUX_PKG_SRCDIR/
	done

	LDFLAGS+=" -landroid-glob"
}
