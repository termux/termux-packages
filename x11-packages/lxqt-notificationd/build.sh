TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="The LXQt notification daemon"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-notificationd/releases/download/${TERMUX_PKG_VERSION}/lxqt-notificationd-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=fe2c2bd289d42f6439a44163eb771237230bb1377020e1fbd49de34645989be2
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, liblxqt, libnotify"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

