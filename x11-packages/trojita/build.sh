TERMUX_PKG_HOMEPAGE=https://github.com/KDE/trojita
TERMUX_PKG_DESCRIPTION="Fast, lightweight and standard-compliant IMAP e-mail client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <yisus7u7v@gmail.com>"
TERMUX_PKG_VERSION=0.7
TERMUX_PKG_SRCURL=https://github.com/KDE/trojita/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7cf5e2202343508904e553db239b02754a98aebf6d2a2d90aa2a089724029a20
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtsvg, librsvg, libpng, qt5-qtxmlpatterns, qt5-qtwebsockets, qt5-qtwebkit, qt5-qtwebchannel"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
# Cmake cannot find Qt5WebKitWidgets on i686 
TERMUX_PKG_BLACKLISTED_ARCHES="i686"
