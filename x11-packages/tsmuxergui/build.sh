TERMUX_PKG_HOMEPAGE=https://github.com/justdan96/tsMuxer
TERMUX_PKG_DESCRIPTION="A transport stream muxer for remuxing/muxing elementary streams"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION_REAL=nightly-2022-11-23-02-43-45
TERMUX_PKG_VERSION=$(cut -d- -f2,3,4 <<< "$_VERSION_REAL" | tr '-' '.')
TERMUX_PKG_SRCURL=https://github.com/justdan96/tsMuxer/archive/refs/tags/${_VERSION_REAL}.tar.gz
TERMUX_PKG_SHA256=049e908d2b8d886cc2b75ef582f6000027db71e22accf9797463fc0841ab01a7
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtmultimedia"
TERMUX_PKG_BUILD_DEPENDS="freetype, qt5-qtbase-cross-tools, qt5-qttools-cross-tools, zlib"
TERMUX_PKG_RM_AFTER_INSTALL="bin/tsmuxer"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_INSTALL_DATADIR=share -DTSMUXER_GUI=ON"
termux_step_post_make_install() {
	mv ${TERMUX_PREFIX}/bin/tsMuxerGUI ${TERMUX_PREFIX}/bin/tsmuxergui
}
