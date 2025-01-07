TERMUX_PKG_HOMEPAGE=https://github.com/lxqt/lxqt-menu-data
TERMUX_PKG_DESCRIPTION="Menu files for LXQt Panel, Configuration Center and PCManFM-Qt/libfm-qt"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-menu-data/releases/download/$TERMUX_PKG_VERSION/lxqt-menu-data-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=d2d2187313c16fc435a7313e53b80ace7ccba0b5de6c0d9cd53bfdfa13d5eab4
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qtbase, qt6-qttools"
TERMUX_PKG_BREAKS="lxqt-panel (<= 1.3.0)"
TERMUX_PKG_CONFLICTS="lxqt-panel (<= 1.3.0)"
TERMUX_PKG_AUTO_UPDATE=true
