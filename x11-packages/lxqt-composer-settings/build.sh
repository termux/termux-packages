TERMUX_PKG_HOMEPAGE=https://github.com/Yisus7u7/lxqt-composer-settings
TERMUX_PKG_DESCRIPTION="lxqt-composer-settings is an unofficial application to configure composition effects in LXQt."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SRCURL=https://github.com/Yisus7u7/lxqt-composer-settings/releases/download/${TERMUX_PKG_VERSION}/lxqt-composer-settings-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d538a73302dd81c85fa3e9d3b2be7937435a73321b6dc11099db75d033181d50
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtsvg, xcompmgr, picom"
TERMUX_PKG_RECOMMENDS="featherpad"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure(){
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" PREFIX=${TERMUX_PREFIX}
}
