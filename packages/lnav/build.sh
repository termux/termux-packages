TERMUX_PKG_HOMEPAGE=https://lnav.org/
TERMUX_PKG_DESCRIPTION="An advanced log file viewer for the small-scale"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.0"
TERMUX_PKG_SRCURL=https://github.com/tstack/lnav/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bf142441fc85e99c256ebe661e4199768acbd340da1344554da49a9e867a49ea
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-execinfo, libandroid-glob, libandroid-spawn, libandroid-utimes, libarchive, libbz2, libc++, libcurl, libsqlite, libunistring, pcre2, readline, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-system-paths
--disable-static
--with-pcre2=$TERMUX_PREFIX
ac_cv_path_CARGO_CMD=
"

termux_step_pre_configure() {
	# for bundled notcurses repository
	(
		cd src/third-party/notcurses
		patch -p1 -i "$TERMUX_PKG_BUILDER_DIR"/../notcurses/include-notcurses-ncport.h.patch
		patch -p1 -i "$TERMUX_PKG_BUILDER_DIR"/../notcurses/src-lib-termdesc.h.patch
	)

	autoreconf -fi

	CXXFLAGS+=" -DC4_LINUX -Wno-c++11-narrowing"
	LDFLAGS+=" -landroid-glob -landroid-spawn -landroid-utimes"
}
