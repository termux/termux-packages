TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bc/
TERMUX_PKG_DESCRIPTION="Arbitrary precision numeric processing language"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.08.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/bc/bc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ae470fec429775653e042015edc928d07c8c3b2fc59765172a330d3d87785f86
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="readline,flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--infodir=$TERMUX_PREFIX/share/info
--mandir=$TERMUX_PREFIX/share/man
--with-readline
"
