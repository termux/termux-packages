TERMUX_PKG_HOMEPAGE=https://www.texstudio.org/
TERMUX_PKG_DESCRIPTION="A fully featured LaTeX editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.3.1
TERMUX_PKG_SRCURL=https://github.com/texstudio-org/texstudio/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=30fa3d4718ce793e4fe5c0c1a3d7d022cb63acc05272cfc0cd820848bcf48b00
TERMUX_PKG_DEPENDS="hunspell, libc++, libx11, poppler-qt, qt5-qtbase, qt5-qtdeclarative, qt5-qtsvg, qt5-qttools, quazip, texstudio-data, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qtdeclarative-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_RECOMMENDS="ghostscript"
TERMUX_PKG_SUGGESTS="texlive-installer"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
PKG_CONFIG=pkg-config
PREFIX=$TERMUX_PREFIX
USE_SYSTEM_HUNSPELL=1
USE_SYSTEM_QUAZIP=1
"

termux_step_post_get_source() {
	termux_download \
		"https://github.com/gentoo/gentoo/raw/e70f62a2157efbb0914a18c5a4f412c79df45995/app-office/texstudio/files/texstudio-3.0.5-quazip1.patch" \
		$TERMUX_PKG_CACHEDIR/texstudio-3.0.5-quazip1.patch \
		96225276c9a78952508813a35d6f8d640cc9c799b88db040444e8a9d49c11392
	cat $TERMUX_PKG_CACHEDIR/texstudio-3.0.5-quazip1.patch | patch --silent -p1
}

termux_step_configure() {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}
