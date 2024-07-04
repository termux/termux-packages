TERMUX_PKG_HOMEPAGE=https://keepassxc.org/
TERMUX_PKG_DESCRIPTION="Cross-platform community-driven port of Keepass password manager"
# KeePassXC code is licensed under GPL-2 or GPL-3.
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE.BSD, LICENSE.CC0, LICENSE.GPL-2, LICENSE.GPL-3, LICENSE.LGPL-2.1, LICENSE.LGPL-3, LICENSE.MIT, LICENSE.NOKIA-LGPL-EXCEPTION, LICENSE.OFL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.9"
TERMUX_PKG_SRCURL="https://github.com/keepassxreboot/keepassxc/releases/download/${TERMUX_PKG_VERSION}/keepassxc-${TERMUX_PKG_VERSION}-src.tar.xz"
TERMUX_PKG_SHA256=3c44e45f22c00ddac63d8bc11054b4b0ada0222ffac08d3ed70f196cb9ed46fd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="argon2, botan3, libc++, libminizip, libqrencode, libx11, libxtst, qt5-qtbase, qt5-qtsvg, qt5-qtx11extras, readline, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_XC_NETWORKING=ON
-DWITH_XC_SSHAGENT=ON
-DWITH_XC_UPDATECHECK=OFF
"
