TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="KDE Access to window manager"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.68.0
TERMUX_PKG_SRCURL="http://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_NAME}-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=859c930a04c2588f792bfb9a28ed40b226db632b15c2851b186301b70d4c825a
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras"
TERMUX_PKG_BUILD_DEPENDS="cmake, extra-cmake-modules, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_INSTALL_PREFIX=${TERMUX_PREFIX}"

termux_step_install_license() {
    install -Dm644 "${TERMUX_PKG_SRCDIR}/COPYING.LIB" "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/LICENSE"
}
