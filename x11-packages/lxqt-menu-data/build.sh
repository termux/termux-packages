TERMUX_PKG_HOMEPAGE=https://github.com/lxqt/lxqt-menu-data
TERMUX_PKG_DESCRIPTION="Menu files for LXQt Panel, Configuration Center and PCManFM-Qt/libfm-qt"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-menu-data/releases/download/$TERMUX_PKG_VERSION/lxqt-menu-data-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=820549ebd50a7437a9af5f229d0a5611944473e1f74bc7c8a2829a7606a2f99e
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_BREAKS="lxqt-panel (<= 1.3.0)"
TERMUX_PKG_CONFLICTS="lxqt-panel (<= 1.3.0)"
TERMUX_PKG_AUTO_UPDATE=true
