TERMUX_PKG_HOMEPAGE=https://github.com/justdan96/tsMuxer
TERMUX_PKG_DESCRIPTION="A transport stream muxer for remuxing/muxing elementary streams"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_REVISION=1
_VERSION_REAL=nightly-2021-12-05-02-09-30
TERMUX_PKG_VERSION=$(cut -d- -f2,3,4 <<< "$_VERSION_REAL" | tr '-' '.')
TERMUX_PKG_SRCURL=https://github.com/justdan96/tsMuxer/archive/refs/tags/${_VERSION_REAL}.tar.gz
TERMUX_PKG_SHA256=676f7741fb897ec53a975fcb6a0c4d5466d680a12e82b54b39cbf48d91bb14fb
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtdeclarative, qt5-qtmultimedia, qt5-qttools"
TERMUX_PKG_BUILD_DEPENDS="freetype, qt5-qtbase-cross-tools, qt5-qttools-cross-tools, zlib"
TERMUX_PKG_RM_AFTER_INSTALL="bin/tsmuxer"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_INSTALL_DATADIR=share -DTSMUXER_GUI=ON"
termux_step_post_make_install() {
	mv ${TERMUX_PREFIX}/bin/tsMuxerGUI ${TERMUX_PREFIX}/bin/tsmuxergui
}
