TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Extra CMake modules (KDE)"
TERMUX_PKG_LICENSE="BSD-3-Clause"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.82.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="http://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/extra-cmake-modules-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=5972ec6d78c3e95ab9cbecdb0661c158570e868466357c5cec2b63a4251ecce4
TERMUX_PKG_DEPENDS="cmake"

termux_step_install_license() {
    install -Dm644 "${TERMUX_PKG_SRCDIR}/LICENSES/BSD-3-Clause.txt" "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/LICENSE"
}

