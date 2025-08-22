TERMUX_PKG_HOMEPAGE=https://www.lighttpd.net
TERMUX_PKG_DESCRIPTION="Fast webserver with minimal memory footprint"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.81"
TERMUX_PKG_SRCURL=https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d7d42c3fd2fd94b63c915aa7d18f4da3cac5937ddba33e909f81cf50842a5840
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-spawn, libbz2, libcrypt, openssl, pcre2, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwith_bzip=enabled
-Dwith_openssl=true
-Dwith_zlib=enabled
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/lighttpd-angel"
TERMUX_PKG_SERVICE_SCRIPT=("lighttpd" "if [ -f \"$TERMUX_ANDROID_HOME/.lighttpd/lighttpd.conf\" ]; then CONFIG=\"$TERMUX_ANDROID_HOME/.lighttpd/lighttpd.conf\"; else CONFIG=\"$TERMUX_PREFIX/etc/lighttpd/lighttpd.conf\"; fi\nexec lighttpd -D -f \$CONFIG 2>&1")

TERMUX_PKG_CONFFILES="
etc/lighttpd/lighttpd.conf
etc/lighttpd/modules.conf
"

termux_step_post_get_source() {
	mv CMakeLists.txt{,.unused}
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-spawn"
}

termux_step_post_make_install() {
	# Install example config file
	install -Dm600 -t $TERMUX_PREFIX/etc/lighttpd/ \
		$TERMUX_PKG_SRCDIR/doc/config/lighttpd.conf \
		$TERMUX_PKG_SRCDIR/doc/config/modules.conf
	install -Dm600 -t $TERMUX_PREFIX/etc/lighttpd/conf.d \
		$TERMUX_PKG_SRCDIR/doc/config/conf.d/*.conf
	install -Dm600 -t $TERMUX_PREFIX/etc/lighttpd/vhosts.d \
		$TERMUX_PKG_SRCDIR/doc/config/vhosts.d/vhosts.template

	cd $TERMUX_PKG_SRCDIR/doc/config
	TERMUX_PKG_CONFFILES+="$(find conf.d -type f -iname "*.conf" | sed -E 's/(.*)/etc\/lighttpd\/\1/g')"
}
