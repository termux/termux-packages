TERMUX_PKG_HOMEPAGE=https://lnav.org/
TERMUX_PKG_DESCRIPTION="An advanced log file viewer for the small-scale"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.10.1
TERMUX_PKG_SRCURL=https://github.com/tstack/lnav/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4af855a463493105ae0746fc0da80304a689b5394eb6abfeede4dd843127c8bc
TERMUX_PKG_DEPENDS="libandroid-glob, libarchive, libbz2, libcurl, ncurses, pcre, readline, sqlite, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-system-paths
ac_cv_header_execinfo_h=no
"

termux_step_pre_configure() {
	autoreconf -fi

	CPPFLAGS+=" -D_PATH_VARTMP=\\\"$TERMUX_PREFIX/tmp\\\""
	LDFLAGS+=" -landroid-glob"
}
