TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Hardware integration and detection'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.6.0
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/solid-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=88f67f369c720aaa0d347ee09273684335505c4f8faf5f7684d1acb7229455f1
TERMUX_PKG_DEPENDS="libimobiledevice, libplist, qt6-qtbase, util-linux"
# media-player-info, systemd-libs, udisks2, upower can be added to TERMUX_PKG_DEPENDS when available
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtdeclarative, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
