TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="PCManFM-Qt is the file manager of LXQt"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL="https://github.com/lxqt/pcmanfm-qt/releases/download/${TERMUX_PKG_VERSION}/pcmanfm-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=fa45cc0d3e870db3fb56f474e854aa1284576023082b770b3e4a44410f22cce3
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras, libfm-qt, liblxqt, lxmenu-data"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

