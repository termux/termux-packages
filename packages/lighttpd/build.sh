TERMUX_PKG_HOMEPAGE=https://www.lighttpd.net
TERMUX_PKG_DESCRIPTION="Fast webserver with minimal memory footprint"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.64
TERMUX_PKG_SRCURL=https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e1489d9fa7496fbf2e071c338b593b2300d38c23f1e5967e52c9ef482e1b0e26
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-bzip2 --with-openssl --with-pcre --with-zlib"
TERMUX_PKG_DEPENDS="libbz2, openssl, pcre, libcrypt, libandroid-glob, zlib"
TERMUX_PKG_RM_AFTER_INSTALL="bin/lighttpd-angel"
TERMUX_PKG_SERVICE_SCRIPT=("lighttpd" "if [ -f \"$TERMUX_ANDROID_HOME/.lighttpd/lighttpd.conf\" ]; then CONFIG=\"$TERMUX_ANDROID_HOME/.lighttpd/lighttpd.conf\"; else CONFIG=\"$TERMUX_PREFIX/etc/lighttpd/lighttpd.conf\"; fi\nexec lighttpd -D -f \$CONFIG 2>&1")

termux_step_pre_configure() {
	LDFLAGS="$LDFLAGS -landroid-glob"
}

termux_step_post_make_install() {
	# Install example config file
	mkdir -p $TERMUX_PREFIX/etc/lighttpd
	install -Dm600 $TERMUX_PKG_SRCDIR/doc/config/lighttpd.conf $TERMUX_PREFIX/etc/lighttpd/
}
