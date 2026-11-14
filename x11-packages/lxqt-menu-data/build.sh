TERMUX_PKG_HOMEPAGE=https://github.com/lxqt/lxqt-menu-data
TERMUX_PKG_DESCRIPTION="Menu files for LXQt Panel, Configuration Center and PCManFM-Qt/libfm-qt"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-menu-data/releases/download/$TERMUX_PKG_VERSION/lxqt-menu-data-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=74983c6d27d9b79ba5a20db645a554ea8065cc7e9faa657363a77988a7228a74
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qtbase, qt6-qttools"
TERMUX_PKG_BREAKS="lxqt-panel (<= 1.3.0)"
TERMUX_PKG_CONFLICTS="lxqt-panel (<= 1.3.0)"
TERMUX_PKG_AUTO_UPDATE=true
