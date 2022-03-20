TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="The LXQt notification daemon"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-notificationd/releases/download/${TERMUX_PKG_VERSION}/lxqt-notificationd-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=94c10fd904995d3eea3b587dd521ed01b839d863ff80205af0af8cab6cb2a660
TERMUX_PKG_DEPENDS="qt5-qtbase, liblxqt, libnotify"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

