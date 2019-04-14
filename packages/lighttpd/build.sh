TERMUX_PKG_HOMEPAGE=https://www.lighttpd.net
TERMUX_PKG_DESCRIPTION="Fast webserver with minimal memory footprint"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=1.4.53
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=3bdfce1cf3e9650a556a8c26fb15342c5717c63f530c54693db632b0371dcb78
TERMUX_PKG_SRCURL=https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-bzip2 --with-openssl --with-pcre --with-zlib"
TERMUX_PKG_DEPENDS="libbz2, openssl, pcre, libcrypt, libandroid-glob, zlib"
TERMUX_PKG_RM_AFTER_INSTALL="bin/lighttpd-angel"

termux_step_pre_configure() {
	# liblog for syslog:
	LDFLAGS="$LDFLAGS -llog -landroid-glob"
}
