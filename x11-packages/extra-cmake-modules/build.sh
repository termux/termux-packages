TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Extra CMake modules (KDE)"
TERMUX_PKG_LICENSE="BSD-3-Clause"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.87.0
TERMUX_PKG_SRCURL="http://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/extra-cmake-modules-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=541ca70d8e270614d19d8fd9e55f97b55fa1dc78d6538c6f6757be372ef8bcab
TERMUX_PKG_DEPENDS="cmake"

termux_step_install_license() {
    install -Dm644 "${TERMUX_PKG_SRCDIR}/LICENSES/BSD-3-Clause.txt" "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/LICENSE"
}

