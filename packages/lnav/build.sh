TERMUX_PKG_HOMEPAGE=https://lnav.org/
TERMUX_PKG_DESCRIPTION="An advanced log file viewer for the small-scale"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.11.1
TERMUX_PKG_SRCURL=https://github.com/tstack/lnav/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7d73ceeeae0fdc61cffce0f8a7a3435aa91b401b67d233ffaa018faab00d7d3f
TERMUX_PKG_DEPENDS="libandroid-execinfo, libandroid-glob, libarchive, libbz2, libc++, libcurl, libsqlite, ncurses, pcre2, readline, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-system-paths
--disable-static
--with-pcre2=$TERMUX_PREFIX
"

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/sys_time.c src/
}

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" -landroid-glob"
}
