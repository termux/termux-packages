TERMUX_PKG_HOMEPAGE=https://lnav.org/
TERMUX_PKG_DESCRIPTION="An advanced log file viewer for the small-scale"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.13.2"
TERMUX_PKG_SRCURL=https://github.com/tstack/lnav/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3501b921c0acb435f85bd2ce589b4d8ba205a87ed855926e65a6ad165431b331
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
