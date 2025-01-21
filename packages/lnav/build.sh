TERMUX_PKG_HOMEPAGE=https://lnav.org/
TERMUX_PKG_DESCRIPTION="An advanced log file viewer for the small-scale"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.3"
TERMUX_PKG_SRCURL=https://github.com/tstack/lnav/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7ba030e5da5b59cd9ea7c0d82aef3af1a6ee1969cab6e22e4bb0f37a96005c7a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-execinfo, libandroid-glob, libandroid-utimes, libarchive, libbz2, libc++, libcurl, libsqlite, ncurses, pcre2, readline, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-system-paths
--disable-static
--with-pcre2=$TERMUX_PREFIX
ac_cv_path_CARGO_CMD=
"

termux_step_pre_configure() {
	autoreconf -fi

	CXXFLAGS+=" -DC4_LINUX"
	LDFLAGS+=" -landroid-glob -landroid-utimes"
}
