TERMUX_PKG_HOMEPAGE=https://github.com/nicm/fdm
TERMUX_PKG_DESCRIPTION="A program designed to fetch mail from POP3 or IMAP servers, or receive local mail from stdin, and deliver it in various ways"
TERMUX_PKG_LICENSE="ISC, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2
TERMUX_PKG_SRCURL=https://github.com/nicm/fdm/releases/download/${TERMUX_PKG_VERSION}/fdm-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=53aad117829834e21c1b9bf20496a1aa1c0e0fb98fe7735e1e73314266fb6c16
TERMUX_PKG_DEPENDS="libandroid-glob, libtdb, openssl, pcre2, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
--localstatedir=$TERMUX_PREFIX/var
--disable-static
--enable-pcre2
"

termux_step_pre_configure() {
	# Source distribution does not have separate license files
	for f in LICENSE LICENSE.BSD; do
		cp $TERMUX_PKG_BUILDER_DIR/$f $TERMUX_PKG_SRCDIR/
	done

	LDFLAGS+=" -landroid-glob"
}
