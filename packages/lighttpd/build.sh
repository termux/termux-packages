TERMUX_PKG_HOMEPAGE=http://www.lighttpd.net
TERMUX_PKG_DESCRIPTION="Web server optimized for speed-critical environments while remaining standards-compliant, secure and flexible"
TERMUX_PKG_VERSION=1.4.45
TERMUX_PKG_SRCURL=http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1c97225deea33eefba6d4158c2cef27913d47553263516bbe9d2e2760fc43a3f
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-bzip2 --with-openssl --with-pcre --with-zlib"
TERMUX_PKG_DEPENDS="libbz2, openssl, pcre, libcrypt, libandroid-glob"
TERMUX_PKG_RM_AFTER_INSTALL="bin/lighttpd-angel"

termux_step_pre_configure () {
	# liblog for syslog:
	LDFLAGS="$LDFLAGS -llog -landroid-glob"
}
