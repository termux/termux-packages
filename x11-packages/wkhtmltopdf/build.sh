TERMUX_PKG_HOMEPAGE=https://wkhtmltopdf.org/
TERMUX_PKG_DESCRIPTION="wkhtmltopdf and wkhtmltoimage are command line tools to render HTML into PDF and various image formats using the QT Webkit rendering engine."
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <jesuspixel5@gmail.com>"
TERMUX_PKG_VERSION=0.12.6
TERMUX_PKG_SRCURL=https://github.com/wkhtmltopdf/wkhtmltopdf/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=adcced78492e7366d940c66a1327a85d3ae8c45190f486f545fdaa84cac662f0
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtsvg, qt5-qtwebkit, qt5-qtxmlpatterns, xorg-server, python"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="i686"

termux_step_configure () {
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
}

termux_step_make_install () {
        cd ${TERMUX_PKG_SRCDIR}/bin
        install -Dm700 -t ${TERMUX_PREFIX}/lib ./*.so*
	install -Dm700 -t ${TERMUX_PREFIX}/bin ./wkhtmltoimage ./wkhtmltopdf
}

