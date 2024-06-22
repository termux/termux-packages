TERMUX_PKG_HOMEPAGE=https://github.com/KDE/trojita
TERMUX_PKG_DESCRIPTION="Fast, lightweight and standard-compliant IMAP e-mail client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION=0.7
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/KDE/trojita/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7cf5e2202343508904e553db239b02754a98aebf6d2a2d90aa2a089724029a20
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtsvg, qt5-qtwebkit, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_TESTS=OFF
"
