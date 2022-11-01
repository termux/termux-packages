TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="KDE Access to window manager"
TERMUX_PKG_LICENSE="LGPL-2.1, LGPL-3.0, MIT"
TERMUX_PKG_LICENSE_FILE="\
LICENSES/CC0-1.0.txt
LICENSES/LGPL-2.1-only.txt
LICENSES/LGPL-2.1-or-later.txt
LICENSES/LGPL-3.0-only.txt
LICENSES/LicenseRef-KDE-Accepted-LGPL.txt
LICENSES/MIT.txt"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.99.0
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kwindowsystem-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f4d13fbf562c05075bb59f997a0de567f96c008a379b7c796d2ca26c01a7f877
TERMUX_PKG_DEPENDS="libc++, libx11, libxcb, libxfixes, qt5-qtbase, qt5-qtx11extras, xcb-util-keysyms"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_INSTALL_PREFIX=${TERMUX_PREFIX}"
