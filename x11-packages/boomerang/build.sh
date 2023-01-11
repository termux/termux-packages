TERMUX_PKG_HOMEPAGE=https://github.com/BoomerangDecompiler/boomerang
TERMUX_PKG_DESCRIPTION="A general, open source machine code decompiler"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.TERMS"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.2
TERMUX_PKG_SRCURL=https://github.com/BoomerangDecompiler/boomerang/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1d2c9c2f5de1a3e1d5fe3879e82bca268d1c49e6ba3d0a7848695f18c594384d
TERMUX_PKG_DEPENDS="capstone, libc++, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBOOMERANG_BUILD_UNIT_TESTS=OFF
"
