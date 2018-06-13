TERMUX_PKG_HOMEPAGE=http://www.lighttpd.net
TERMUX_PKG_DESCRIPTION="Fast webserver with minimal memory footprint"
TERMUX_PKG_VERSION=1.4.49
TERMUX_PKG_SHA256=aedf49d7127d9e4c0ea56618e9e945a17674dc46a37ac7990120f87dd939ce09
TERMUX_PKG_SRCURL=http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-bzip2 --with-openssl --with-pcre --with-zlib"
TERMUX_PKG_DEPENDS="libbz2, openssl, pcre, libcrypt, libandroid-glob"
TERMUX_PKG_RM_AFTER_INSTALL="bin/lighttpd-angel"

termux_step_pre_configure () {
	# liblog for syslog:
	LDFLAGS="$LDFLAGS -llog -landroid-glob"
}
