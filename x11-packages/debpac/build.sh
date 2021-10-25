TERMUX_PKG_HOMEPAGE=https://github.com/ThiBsc/debpac
TERMUX_PKG_DESCRIPTION="A Debian package creator assistant"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <jesuspixel5@gmail.com>"
TERMUX_PKG_VERSION=1.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/ThiBsc/debpac/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=402f9dfcc739fb64666832f1a0d5b47295c900a22232150af4cc069b420515c9
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure () {
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
        PREFIX="${TERMUX_PREFIX}"
}

termux_step_make_install () {
	cd ${TERMUX_PKG_SRCDIR}
	install -Dm700 -t ${TERMUX_PREFIX}/bin ./debpac
}
