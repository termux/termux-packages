TERMUX_PKG_HOMEPAGE=https://keepassxc.org/
TERMUX_PKG_DESCRIPTION="Cross-platform community-driven port of Keepass password manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.6
TERMUX_PKG_SRCURL="https://github.com/keepassxreboot/keepassxc/releases/download/${TERMUX_PKG_VERSION}/keepassxc-${TERMUX_PKG_VERSION}-src.tar.xz"
TERMUX_PKG_SHA256=3603b11ac39b289c47fac77fa150e05fd64b393d8cfdf5732dc3ef106650a4e2
TERMUX_PKG_DEPENDS="argon2, libcurl, libgcrypt, libqrencode, libsodium, libxtst, qt5-qtbase, qt5-qtsvg, qt5-qtx11extras"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_XC_NETWORKING=ON
-DWITH_XC_SSHAGENT=ON
-DWITH_XC_UPDATECHECK=OFF
"
