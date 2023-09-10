TERMUX_PKG_HOMEPAGE="https://spglib.github.io/spglib/index.html"
TERMUX_PKG_DESCRIPTION="C library for finding and handling crystal symmetries"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL="https://github.com/spglib/spglib/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=31bca273a1bc54e1cff4058eebe7c0a35d5f9b489579e84667d8e005c73dcc13
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_Fortran=OFF
-DUSE_OMP=ON
"
